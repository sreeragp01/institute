from rest_framework import serializers
from .models import Enquiry

class EnquirySerializer(serializers.ModelSerializer):
    assigned_counselor_name = serializers.ReadOnlyField(source='assigned_counselor.get_full_name')

    class Meta:
        model = Enquiry
        fields = '__all__'
        read_only_fields = ('created_at', 'updated_at', 'assigned_counselor_name')
