from rest_framework import serializers
from accounts.models import User
from accounts.serializers import UserSerializer
from courses.serializers import CourseSerializer, BatchSerializer
from .models import StudentProfile, LeaveRequest, ParentProfile

class StudentProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    course_name = serializers.CharField(source='course.name', read_only=True)
    batch_name = serializers.CharField(source='batch.name', read_only=True)

    class Meta:
        model = StudentProfile
        fields = ['id', 'user', 'roll_number', 'course', 'course_name', 'batch', 'batch_name', 'guardian_name', 'guardian_contact']

class LeaveRequestSerializer(serializers.ModelSerializer):
    student_name = serializers.CharField(source='student.get_full_name', read_only=True)

    class Meta:
        model = LeaveRequest
        fields = '__all__'
        read_only_fields = ['student', 'status', 'reviewed_by']

class ParentProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    students = StudentProfileSerializer(many=True, read_only=True)

    class Meta:
        model = ParentProfile
        fields = ['id', 'user', 'students', 'relationship']
