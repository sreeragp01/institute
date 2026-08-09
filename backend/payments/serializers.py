from rest_framework import serializers
from .models import FeeStructure, FeePayment

class FeeStructureSerializer(serializers.ModelSerializer):
    course_name = serializers.CharField(source='course.name', read_only=True)

    class Meta:
        model = FeeStructure
        fields = '__all__'

class FeePaymentSerializer(serializers.ModelSerializer):
    student_name = serializers.CharField(source='student.email', read_only=True)

    class Meta:
        model = FeePayment
        fields = '__all__'
