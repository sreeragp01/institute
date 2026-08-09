from rest_framework import serializers
from .models import Assignment, Submission

class SubmissionSerializer(serializers.ModelSerializer):
    student_email = serializers.CharField(source='student.email', read_only=True)

    class Meta:
        model = Submission
        fields = ['id', 'assignment', 'student', 'student_email', 'file_url', 'grade', 'feedback', 'submitted_at']
        read_only_fields = ['id', 'student', 'submitted_at']

class AssignmentSerializer(serializers.ModelSerializer):
    subject_name = serializers.CharField(source='subject.name', read_only=True)
    batch_name = serializers.CharField(source='batch.name', read_only=True)
    submissions = SubmissionSerializer(many=True, read_only=True)

    class Meta:
        model = Assignment
        fields = ['id', 'batch', 'batch_name', 'subject', 'subject_name', 'trainer', 'title', 'description', 'due_date', 'submissions', 'created_at']
        read_only_fields = ['id', 'trainer', 'created_at']

    def validate_batch(self, value):
        user = self.context['request'].user
        if value and value.course.institute != user.institute:
            raise serializers.ValidationError("Batch does not belong to your institute.")
        return value

    def validate_subject(self, value):
        user = self.context['request'].user
        if value and value.course.institute != user.institute:
            raise serializers.ValidationError("Subject does not belong to your institute.")
        return value
