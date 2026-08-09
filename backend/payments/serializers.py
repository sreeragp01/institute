from rest_framework import serializers
from .models import FeeStructure, FeePayment

class FeeStructureSerializer(serializers.ModelSerializer):
    course_name = serializers.CharField(source='course.name', read_only=True)

    class Meta:
        model = FeeStructure
        fields = ['id', 'institute', 'course', 'course_name', 'name', 'total_amount', 'installment_count']
        read_only_fields = ['id', 'institute']

class FeePaymentSerializer(serializers.ModelSerializer):
    student_name = serializers.CharField(source='student.email', read_only=True)

    class Meta:
        model = FeePayment
        fields = ['id', 'institute', 'student', 'student_name', 'amount', 'due_date', 'status', 'paid_date', 'transaction_id', 'receipt_url']
        read_only_fields = ['id', 'institute', 'paid_date', 'transaction_id', 'receipt_url']
