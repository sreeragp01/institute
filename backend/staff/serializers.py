from rest_framework import serializers
from accounts.models import User
from accounts.serializers import UserSerializer
from courses.serializers import SubjectSerializer
from .models import TrainerProfile, StaffLeaveRequest

class TrainerProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    assigned_subjects = SubjectSerializer(many=True, read_only=True)

    class Meta:
        model = TrainerProfile
        fields = ['id', 'user', 'employee_id', 'qualification', 'specialization', 'assigned_subjects', 'monthly_salary', 'joining_date']

class StaffLeaveRequestSerializer(serializers.ModelSerializer):
    trainer_name = serializers.CharField(source='trainer.get_full_name', read_only=True)

    class Meta:
        model = StaffLeaveRequest
        fields = '__all__'
        read_only_fields = ['trainer', 'status', 'reviewed_by']
