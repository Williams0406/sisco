from django.contrib import admin
from django.urls import include, path
from rest_framework_simplejwt.views import TokenRefreshView

from seguridad.views import LoginView


urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/login/', LoginView.as_view(), name='token_obtain_pair'),
    path('api/auth/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/maestros/', include('maestros.urls')),
    path('api/movimientos/', include('movimientos.urls')),
    path('api/reportes/', include('reportes.urls')),
    path('api/seguridad/', include('seguridad.urls')),
]
