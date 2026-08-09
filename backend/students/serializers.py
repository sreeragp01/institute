from rest_framework import serializers
from .models import StudentProfile, LeaveRequest, ParentProfile

class StudentProfileSerializer(serializers.ModelSerializer):
    user_email = serializers.CharField(source='user.email', read_only=True)
    course_name = serializers.CharField(source='course.name', read_only=True)
    batch_name = serializers.CharField(source='batch.name', read_only=True)

    class Meta:
        model = StudentProfile
        fields = ['id', 'user', 'user_email', 'roll_number', 'course', 'course_name', 'batch', 'batch_name', 'guardian_name', 'guardian_contact']
        read_only_fields = ['id', 'user', 'roll_number']

    def validate_course(self, value):
        user = self.context['request'].user
        if value and value.institute != user.institute:
            raise serializers.ValidationError("Course does not belong to your institute.")
        return value

class LeaveRequestSerializer(serializers.ModelSerializer):
    student_name = serializers.CharField(source='student.get_full_name', read_only=True)

    class Meta:
        model = LeaveRequest
        fields = ['id', 'student', 'student_name', 'from_date', 'to_date', 'reason', 'status', 'reviewed_by', 'remarks', 'created_at']
        read_only_fields = ['id', 'student', 'status', 'reviewed_by', 'created_at']

class ParentProfileSerializer(serializers.ModelSerializer):
    user_email = serializers.CharField(source='user.email', read_only=True)

    class Meta:
        model = ParentProfile
        fields = ['id', 'user', 'user_email', 'students', 'relationship']
        read_only_fields = ['id', 'user']
