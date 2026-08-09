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
    """
    def has_object_permission(self, request, view, obj):
        if not (request.user and request.user.is_authenticated):
            return False
        if request.user.role == User.Role.SUPER_ADMIN:
            return True

        # Check direct institute attribute
        if hasattr(obj, 'institute') and obj.institute is not None:
            return obj.institute == request.user.institute

        # Check nested user.institute attribute
        if hasattr(obj, 'user') and hasattr(obj.user, 'institute'):
            return obj.user.institute == request.user.institute

        # Fallback to true if object is not institute-bound
        return True
