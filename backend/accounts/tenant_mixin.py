from rest_framework import permissions

class TenantScopedQuerySetMixin:
    """
    Mixin that automatically filters querysets by the logged-in user's institute.
    Super Admins can see all tenant records across institutes.
    """
    def get_queryset(self):
        queryset = super().get_queryset()
        user = self.request.user

        if not user or not user.is_authenticated:
            return queryset.none()

        # Super Admin accesses across all institutes
        if user.role == 'SUPER_ADMIN':
            return queryset

        field_names = [f.name for f in queryset.model._meta.get_fields()]

        # Scoped by user's institute
        if 'institute' in field_names:
            return queryset.filter(institute=user.institute)
        elif 'user' in field_names:
            return queryset.filter(user__institute=user.institute)
        elif 'student' in field_names:
            return queryset.filter(student__institute=user.institute)
        elif 'course' in field_names:
            return queryset.filter(course__institute=user.institute)
        elif 'batch' in field_names:
            return queryset.filter(batch__course__institute=user.institute)

        return queryset
