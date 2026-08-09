from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from accounts.models import User
from accounts.tenant_mixin import TenantScopedQuerySetMixin
from .models import Assignment, Submission
from .serializers import AssignmentSerializer, SubmissionSerializer

class AssignmentListCreateView(TenantScopedQuerySetMixin, generics.ListCreateAPIView):
    queryset = Assignment.objects.all().order_by('-created_at')
    serializer_class = AssignmentSerializer
    permission_classes = [permissions.IsAuthenticated]


class SubmitAssignmentView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, assignment_id):
        user = request.user
        if user.role == User.Role.SUPER_ADMIN:
            assignment = Assignment.objects.filter(id=assignment_id).first()
        else:
            assignment = Assignment.objects.filter(id=assignment_id, batch__course__institute=user.institute).first()

        if not assignment:
            return Response({'detail': 'Assignment not found or access denied.'}, status=status.HTTP_404_NOT_FOUND)

        file_url = request.data.get('file_url', 'https://smec.edu/submissions/demo_solution.pdf')
        submission, _ = Submission.objects.update_or_create(
            assignment=assignment,
            student=user,
            defaults={'file_url': file_url}
        )

        return Response(SubmissionSerializer(submission).data, status=status.HTTP_201_CREATED)

class GradeSubmissionView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def patch(self, request, submission_id):
        user = request.user
        if user.role not in [User.Role.TRAINER, User.Role.ADMIN, User.Role.SUPER_ADMIN]:
            return Response({'detail': 'Only Staff or Admins can grade submissions.'}, status=status.HTTP_403_FORBIDDEN)

        if user.role == User.Role.SUPER_ADMIN:
            submission = Submission.objects.filter(id=submission_id).first()
        else:
            submission = Submission.objects.filter(id=submission_id, student__institute=user.institute).first()

        if not submission:
            return Response({'detail': 'Submission not found or access denied.'}, status=status.HTTP_404_NOT_FOUND)

        grade = request.data.get('grade')
        feedback = request.data.get('feedback', '')

        if grade is not None:
            submission.grade = str(grade)
            submission.feedback = feedback
            submission.save()

        return Response(SubmissionSerializer(submission).data)
