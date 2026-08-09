from rest_framework import permissions
from accounts.models import User

class IsSuperAdmin(permissions.BasePermission):
    """
    Allows access only to Super Admins (Global SaaS platform admins).
    """
    def has_permission(self, request, view):
        return bool(request.user and request.user.is_authenticated and request.user.role == User.Role.SUPER_ADMIN)

class IsInstituteAdmin(permissions.BasePermission):
    """
    Allows access only to Institute Admins or Super Admins.
    """
    def has_permission(self, request, view):
        if not (request.user and request.user.is_authenticated):
            return False
        return request.user.role in [User.Role.ADMIN, User.Role.SUPER_ADMIN]

class IsTrainer(permissions.BasePermission):
    """
    Allows access to Trainers, Admins, or Super Admins.
    """
    def has_permission(self, request, view):
        if not (request.user and request.user.is_authenticated):
            return False
        return request.user.role in [User.Role.TRAINER, User.Role.ADMIN, User.Role.SUPER_ADMIN]

class IsStudent(permissions.BasePermission):
    """
    Allows access to Students, Trainers, Admins, or Super Admins.
    """
    def has_permission(self, request, view):
        if not (request.user and request.user.is_authenticated):
            return False
        return request.user.role in [User.Role.STUDENT, User.Role.TRAINER, User.Role.ADMIN, User.Role.SUPER_ADMIN]

class IsParent(permissions.BasePermission):
    """
    Allows access to Parent accounts.
    """
    def has_permission(self, request, view):
        if not (request.user and request.user.is_authenticated):
            return False
        return request.user.role in [User.Role.PARENT, User.Role.ADMIN, User.Role.SUPER_ADMIN]

class IsTenantObject(permissions.BasePermission):
    """
    Object-level permission ensuring an object belongs to the requesting user's institute.
    Super Admins bypass tenant check.
    FAIL CLOSED: Denies access by default if tenant relationship cannot be proven.
    """
    def has_object_permission(self, request, view, obj):
        if not (request.user and request.user.is_authenticated):
            return False
        if request.user.role == User.Role.SUPER_ADMIN:
            return True

        # 1. Direct institute attribute
        if hasattr(obj, 'institute') and obj.institute is not None:
            return obj.institute == request.user.institute

        # 2. Nested user.institute attribute
        if hasattr(obj, 'user') and hasattr(obj.user, 'institute') and obj.user.institute is not None:
            return obj.user.institute == request.user.institute

        # 3. Nested student.institute attribute
        if hasattr(obj, 'student') and hasattr(obj.student, 'institute') and obj.student.institute is not None:
            return obj.student.institute == request.user.institute

        # 4. Nested course.institute attribute
        if hasattr(obj, 'course') and hasattr(obj.course, 'institute') and obj.course.institute is not None:
            return obj.course.institute == request.user.institute

        # 5. Nested batch.course.institute attribute
        if hasattr(obj, 'batch') and hasattr(obj.batch, 'course') and hasattr(obj.batch.course, 'institute') and obj.batch.course.institute is not None:
            return obj.batch.course.institute == request.user.institute

        # Explicit global objects (e.g. SubscriptionPlan) are allowed
        if getattr(obj, 'is_global', False):
            return True

        # FAIL CLOSED: DENY access by default
        return False
