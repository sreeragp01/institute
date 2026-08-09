from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView

urlpatterns = [
    path('admin/', admin.site.urls),

    # OpenAPI Schema & Docs
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),

    # API v1 Versioned Routes
    path('api/v1/auth/', include('accounts.urls')),
    path('api/v1/students/', include('students.urls')),
    path('api/v1/staff/', include('staff.urls')),
    path('api/v1/courses/', include('courses.urls')),
    path('api/v1/attendance/', include('attendance.urls')),
    path('api/v1/fees/', include('payments.urls')),
    path('api/v1/assignments/', include('assignments.urls')),
    path('api/v1/ai/', include('ai_assistant.urls')),
    path('api/v1/analytics/', include('analytics.urls')),
    path('api/v1/examinations/', include('examinations.urls')),
    path('api/v1/certificates/', include('certificates.urls')),
    path('api/v1/placements/', include('placements.urls')),
    path('api/v1/admissions/', include('admissions.urls')),
    path('api/v1/support/', include('support.urls')),
    path('api/v1/audit/', include('audit.urls')),
]



if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
