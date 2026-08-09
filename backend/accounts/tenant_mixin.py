from rest_framework import permissions

class TenantScopedQuerySetMixin:
    """
    Mixin that automatically filters querysets by the logged-in user's institute.
    Super Admins can see all tenant records.
    """
    def get_queryset(self):
        queryset = super().get_queryset()
        user = self.request.user

        if not user or not user.is_authenticated:
            return queryset.none()

        # Super Admin accesses across all institutes
        if user.role == 'SUPER_ADMIN':
            return queryset

        # Scoped by user's institute
        if hasattr(queryset.model, 'institute'):
            return queryset.filter(institute=user.institute)
        elif hasattr(queryset.model, 'course') and hasattr(queryset.model.course.field.related_model, 'institute'):
            return queryset.filter(course__institute=user.institute)
        elif hasattr(queryset.model, 'batch') and hasattr(queryset.model.batch.field.related_model, 'course'):
            return queryset.filter(batch__course__institute=user.institute)

        return queryset
