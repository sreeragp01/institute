from rest_framework import serializers
from .models import AttendanceSession, AttendanceRecord

class AttendanceRecordSerializer(serializers.ModelSerializer):
    student_name = serializers.CharField(source='student.email', read_only=True)
    subject_name = serializers.CharField(source='session.subject.name', read_only=True)

    class Meta:
        model = AttendanceRecord
        fields = ['id', 'session', 'student', 'student_name', 'subject_name', 'status', 'marked_at']
        read_only_fields = ['id', 'marked_at']

class AttendanceSessionSerializer(serializers.ModelSerializer):
    subject_name = serializers.CharField(source='subject.name', read_only=True)
    batch_name = serializers.CharField(source='batch.name', read_only=True)

    class Meta:
        model = AttendanceSession
        fields = ['id', 'institute', 'batch', 'batch_name', 'subject', 'subject_name', 'trainer', 'date', 'qr_code_secret', 'created_at']
        read_only_fields = ['id', 'institute', 'trainer', 'created_at']

    def validate_batch(self, value):
        user = self.context['request'].user
        if value and value.course.institute != user.institute:
            raise serializers.ValidationError("Batch does not belong to your institute.")
        return value
