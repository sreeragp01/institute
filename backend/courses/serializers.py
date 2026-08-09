from rest_framework import serializers
from .models import Course, Batch, Subject, Timetable

class SubjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Subject
        fields = ['id', 'course', 'code', 'name']
        read_only_fields = ['id']

class CourseSerializer(serializers.ModelSerializer):
    subjects = SubjectSerializer(many=True, read_only=True)

    class Meta:
        model = Course
        fields = ['id', 'institute', 'code', 'name', 'duration_months', 'subjects']
        read_only_fields = ['id', 'institute']

class BatchSerializer(serializers.ModelSerializer):
    course_name = serializers.CharField(source='course.name', read_only=True)

    class Meta:
        model = Batch
        fields = ['id', 'course', 'course_name', 'name', 'start_date', 'end_date', 'trainer']
        read_only_fields = ['id']

class TimetableSerializer(serializers.ModelSerializer):
    subject_name = serializers.CharField(source='subject.name', read_only=True)
    batch_name = serializers.CharField(source='batch.name', read_only=True)

    class Meta:
        model = Timetable
        fields = ['id', 'batch', 'batch_name', 'subject', 'subject_name', 'day_of_week', 'start_time', 'end_time', 'room_number']
        read_only_fields = ['id']
