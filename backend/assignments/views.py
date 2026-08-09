from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
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
        try:
            assignment = Assignment.objects.get(id=assignment_id)
        except Assignment.DoesNotExist:
            return Response({'detail': 'Assignment not found'}, status=status.HTTP_404_NOT_FOUND)

        file_url = request.data.get('file_url', 'https://smec.edu/submissions/demo_solution.pdf')
        submission, _ = Submission.objects.update_or_create(
            assignment=assignment,
            student=request.user,
            defaults={'file_url': file_url}
        )

        return Response(SubmissionSerializer(submission).data, status=status.HTTP_201_CREATED)

class GradeSubmissionView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def patch(self, request, submission_id):
        try:
            submission = Submission.objects.get(id=submission_id)
        except Submission.DoesNotExist:
            return Response({'detail': 'Submission not found'}, status=status.HTTP_404_NOT_FOUND)

        grade = request.data.get('grade')
        feedback = request.data.get('feedback', '')

        if grade is not None:
            submission.grade = str(grade)
            submission.feedback = feedback
            submission.save()

        return Response(SubmissionSerializer(submission).data)
