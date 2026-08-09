from rest_framework import serializers
from .models import TrainerProfile, StaffLeaveRequest

class TrainerProfileSerializer(serializers.ModelSerializer):
    user_email = serializers.CharField(source='user.email', read_only=True)

    class Meta:
        model = TrainerProfile
        fields = ['id', 'user', 'user_email', 'employee_id', 'qualification', 'specialization', 'monthly_salary', 'joining_date']
        read_only_fields = ['id', 'user', 'employee_id']

class StaffLeaveRequestSerializer(serializers.ModelSerializer):
    trainer_name = serializers.CharField(source='trainer.get_full_name', read_only=True)

    class Meta:
        model = StaffLeaveRequest
        fields = ['id', 'trainer', 'trainer_name', 'from_date', 'to_date', 'reason', 'status', 'reviewed_by', 'remarks', 'created_at']
        read_only_fields = ['id', 'trainer', 'status', 'reviewed_by', 'created_at']
