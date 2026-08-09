from rest_framework import serializers
from .models import Company, PlacementDrive, JobApplication

class CompanySerializer(serializers.ModelSerializer):
    class Meta:
        model = Company
        fields = ['id', 'name', 'logo_url', 'website', 'location']

class PlacementDriveSerializer(serializers.ModelSerializer):
    company = CompanySerializer(read_only=True)
    company_id = serializers.IntegerField(write_only=True, required=False)

    class Meta:
        model = PlacementDrive
        fields = ['id', 'title', 'company', 'company_id', 'role_description', 'package_lpa', 'eligibility_criteria', 'drive_date', 'created_at']

class JobApplicationSerializer(serializers.ModelSerializer):
    drive = PlacementDriveSerializer(read_only=True)
    student_name = serializers.CharField(source='student.get_full_name', read_only=True)

    class Meta:
        model = JobApplication
        fields = ['id', 'drive', 'student', 'student_name', 'status', 'applied_at', 'offer_letter_url']
        read_only_fields = ['student']
