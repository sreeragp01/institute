from rest_framework import serializers
from .models import Enquiry

class EnquirySerializer(serializers.ModelSerializer):
    assigned_counselor_name = serializers.ReadOnlyField(source='assigned_counselor.get_full_name')

    class Meta:
        model = Enquiry
        fields = ['id', 'institute', 'candidate_name', 'email', 'phone', 'course_interested', 'source', 'status', 'assigned_counselor', 'assigned_counselor_name', 'notes', 'created_at', 'updated_at']
        read_only_fields = ['id', 'institute', 'created_at', 'updated_at', 'assigned_counselor_name']

    def validate_assigned_counselor(self, value):
        user = self.context['request'].user
        if value and value.institute != user.institute:
            raise serializers.ValidationError("Assigned counselor does not belong to your institute.")
        return value
