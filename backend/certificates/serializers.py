from rest_framework import serializers
from .models import IssuedCertificate

class IssuedCertificateSerializer(serializers.ModelSerializer):
    student_name = serializers.CharField(source='student.get_full_name', read_only=True)
    institute_name = serializers.CharField(source='institute.name', read_only=True)
    course_name = serializers.CharField(source='course.name', read_only=True)

    class Meta:
        model = IssuedCertificate
        fields = [
            'id', 'certificate_number', 'certificate_type', 'verification_code',
            'student', 'student_name', 'institute_name', 'course', 'course_name',
            'issue_date', 'pdf_url'
        ]
