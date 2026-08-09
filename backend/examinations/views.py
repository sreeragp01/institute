from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from accounts.models import User
from accounts.tenant_mixin import TenantScopedQuerySetMixin
from .models import Exam, Question, ExamSubmission
from .serializers import ExamSerializer, QuestionSerializer, ExamSubmissionSerializer

class ExamListView(TenantScopedQuerySetMixin, generics.ListCreateAPIView):
    queryset = Exam.objects.all().order_by('-scheduled_at')
    serializer_class = ExamSerializer
    permission_classes = [permissions.IsAuthenticated]

class ExamDetailView(TenantScopedQuerySetMixin, generics.RetrieveUpdateDestroyAPIView):
    queryset = Exam.objects.all()
    serializer_class = ExamSerializer
    permission_classes = [permissions.IsAuthenticated]

class SubmitExamView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, pk):
        try:
            exam = Exam.objects.get(id=pk)
        except Exam.DoesNotExist:
            return Response({'detail': 'Exam not found'}, status=status.HTTP_404_NOT_FOUND)

        answers = request.data.get('answers', {})
        total_score = 0
        questions = exam.questions.all()

        for q in questions:
            user_ans = answers.get(str(q.id))
            if user_ans is not None and int(user_ans) == q.correct_option:
                total_score += q.marks

        is_passed = total_score >= exam.pass_marks

        submission = ExamSubmission.objects.create(
            exam=exam,
            student=request.user,
            answers=answers,
            marks_obtained=total_score,
            is_passed=is_passed
        )

        # Calculate rank relative to other submissions for this exam
        submissions = list(ExamSubmission.objects.filter(exam=exam).order_by('-marks_obtained'))
        for index, sub in enumerate(submissions):
            sub.rank = index + 1
            if sub.id == submission.id:
                submission.rank = index + 1
            sub.save()

        return Response({
            'message': 'Exam submitted and evaluated successfully!',
            'score': total_score,
            'total_marks': exam.total_marks,
            'is_passed': is_passed,
            'rank': submission.rank,
            'submission': ExamSubmissionSerializer(submission).data
        }, status=status.HTTP_201_CREATED)
