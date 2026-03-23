"""
models.py — BD_SISCO
Generado a partir del script SQL de SQL Server (Microsoft SQL Server).

Estructura general:
  - MAE_*  → Tablas maestras (catálogos)
  - CAB_*  → Cabeceras de transacciones
  - DET_*  → Detalles de transacciones
  - MOV_*  → Movimientos operativos
  - ADM_*  → Administración de permisos

Relaciones principales:
  MAE_SISTEMA → MAE_MODULO → MAE_OPCION ← ADM_PERFIL_OPCIONES ← MAE_PERFIL
  MAE_PERFIL  ← MAE_PERFIL_MAE_USUARIO → MAE_USUARIO
  MAE_GARITA  ← mae_garita_x_usuario  → MAE_USUARIO
  MAE_TIPO_VEHICULO ← MAE_VEHICULO → MAE_CLIENTE, MAE_CHOFER
  MAE_TIPO_VEHICULO ← DET_TARIFARIO → MAE_CLIENTE
  DET_TARIFARIO ← MOV_TICKET → MAE_GARITA, MAE_VEHICULO, MAE_CLIENTE,
                                MAE_CHOFER, MAE_TIPO_INCIDENTE
  MOV_TICKET ← CAB_DOCUMENTO_VENTA → MAE_CLIENTE
  MOV_TICKET ← DET_COBRANZA_CREDITO → CAB_COBRANZA_CREDITO → MAE_CLIENTE
  MAE_TIPO_EGRESO ← CAB_RECIBO_EGRESO → MAE_PROVEEDOR
  MAE_TIPO_INGRESO ← CAB_RECIBO_INGRESO → MAE_CLIENTE
  MAE_TIPO_DOCUMENTO ← MAE_CORRELATIVO
"""

from django.db import models


# ---------------------------------------------------------------------------
# MAESTRAS BASE
# ---------------------------------------------------------------------------

class MaeSistema(models.Model):
    """Sistema al que pertenecen los módulos y opciones."""
    ch_codi_sistema = models.CharField(max_length=3, primary_key=True)
    vc_desl_sistema = models.CharField(max_length=50, null=True, blank=True)
    vc_desc_sistema = models.CharField(max_length=30, null=True, blank=True)
    ch_esta_sistema = models.CharField(max_length=1, null=True, blank=True)
    vc_desc_logo = models.CharField(max_length=50, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_SISTEMA'
        verbose_name = 'Sistema'

    def __str__(self):
        return f'{self.ch_codi_sistema} – {self.vc_desc_sistema}'


class MaeModulo(models.Model):
    """Módulo dentro de un sistema."""
    # Clave primaria compuesta (sistema + módulo)
    ch_codi_sistema = models.ForeignKey(
        MaeSistema,
        on_delete=models.PROTECT,
        db_column='CH_CODI_SISTEMA',
        to_field='ch_codi_sistema',
    )
    ch_codi_modulo = models.CharField(max_length=3)
    vc_desc_modulo = models.CharField(max_length=50, null=True, blank=True)
    ch_esta_modulo = models.CharField(max_length=1, null=True, blank=True)

    class Meta:
        db_table = 'MAE_MODULO'
        unique_together = [('ch_codi_sistema', 'ch_codi_modulo')]
        verbose_name = 'Módulo'

    def __str__(self):
        return f'{self.ch_codi_sistema_id}/{self.ch_codi_modulo} – {self.vc_desc_modulo}'


class MaeOpcion(models.Model):
    """Opción / pantalla dentro de un módulo."""
    ch_codi_sistema = models.CharField(max_length=3)
    ch_codi_modulo_fk = models.ForeignKey(
        MaeModulo,
        on_delete=models.PROTECT,
        db_column='CH_CODI_MODULO_FK_ID',  # columna en BD
        related_name='opciones',
        # Sin to_field → apunta a la PK (id autoincremental)
    )
    ch_codi_opcion = models.CharField(max_length=2)
    vc_desc_opcion = models.CharField(max_length=50, null=True, blank=True)
    vc_desc_nom_ventana = models.CharField(max_length=50, null=True, blank=True)
    vc_tipo_opcion = models.CharField(max_length=3, null=True, blank=True)
    vc_desc_icono_opcion = models.CharField(max_length=50, null=True, blank=True)
    vc_desc_responsable = models.CharField(max_length=50, null=True, blank=True)
    dt_fech_creacion_opcion = models.DateTimeField(null=True, blank=True)
    dt_fech_mod_opcion = models.DateTimeField(null=True, blank=True)
    ch_esta_parametro = models.CharField(max_length=1, null=True, blank=True)
    ch_esta_opcion = models.CharField(max_length=1, null=True, blank=True)
    ch_desc_nom_corto = models.CharField(max_length=50, null=True, blank=True)
    ch_ruta_programa = models.CharField(max_length=50, null=True, blank=True)
    ch_esta_opcion_internet = models.CharField(max_length=1, null=True, blank=True)
    ch_ind_original = models.CharField(max_length=1, null=True, blank=True)

    class Meta:
        db_table = 'MAE_OPCION'
        unique_together = [('ch_codi_sistema', 'ch_codi_modulo_fk', 'ch_codi_opcion')]
        verbose_name = 'Opción'

    def __str__(self):
        return f'{self.ch_codi_sistema}/{self.ch_codi_modulo_fk_id}/{self.ch_codi_opcion}'


class MaePerfil(models.Model):
    """Perfil de seguridad asignable a usuarios."""
    ch_codi_perfil = models.CharField(max_length=3, primary_key=True)
    vc_desc_perfil = models.CharField(max_length=50, null=True, blank=True)
    ch_esta_perfil = models.CharField(max_length=1, null=True, blank=True)

    class Meta:
        db_table = 'MAE_PERFIL'
        verbose_name = 'Perfil'

    def __str__(self):
        return f'{self.ch_codi_perfil} – {self.vc_desc_perfil}'


class AdmPerfilOpciones(models.Model):
    """
    Asignación de opciones a perfiles.
    Relaciones:
      → MAE_PERFIL (ch_codi_perfil)
      → MAE_OPCION (sistema + modulo + opcion)
    """
    ch_codi_sistema = models.CharField(max_length=3)
    ch_codi_modulo = models.CharField(max_length=3)
    ch_codi_opcion = models.CharField(max_length=2)
    ch_codi_perfil = models.ForeignKey(
        MaePerfil,
        on_delete=models.PROTECT,
        db_column='CH_CODI_PERFIL',
        to_field='ch_codi_perfil',
        related_name='opciones_perfil',
    )
    # Nota: la FK compuesta a MAE_OPCION se representa con los tres campos anteriores.
    # Para navegación directa, utilice un manager o una propiedad que filtre MaeOpcion.

    class Meta:
        db_table = 'ADM_PERFIL_OPCIONES'
        unique_together = [('ch_codi_sistema', 'ch_codi_modulo', 'ch_codi_opcion', 'ch_codi_perfil')]
        verbose_name = 'Perfil – Opción'


class MaeUsuario(models.Model):
    """Usuario del sistema."""
    ch_codi_usuario = models.CharField(max_length=20, primary_key=True)
    vc_desc_nomb_usuario = models.CharField(max_length=30, null=True, blank=True)
    ch_codi_centro = models.CharField(max_length=4, null=True, blank=True)
    vc_desc_apell_paterno = models.CharField(max_length=30, null=True, blank=True)
    vc_desc_apell_materno = models.CharField(max_length=30, null=True, blank=True)
    vc_desc_email_usuario = models.CharField(max_length=30, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    vc_host_conexion = models.CharField(max_length=30, null=True, blank=True)
    ch_esta_conexion = models.CharField(max_length=1, null=True, blank=True)
    ch_pass_usua = models.CharField(max_length=10, null=True, blank=True)
    ch_codi_usua = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_ulti_actu = models.DateTimeField(null=True, blank=True)
    ch_codi_cta_upch = models.CharField(max_length=15, null=True, blank=True)
    ch_esta_programa_todos = models.CharField(max_length=1, null=True, blank=True)
    ch_esta_horas_extra = models.CharField(max_length=1, null=True, blank=True)
    ch_esta_autoriza = models.CharField(max_length=1, null=True, blank=True)
    ch_tipo_usuario = models.CharField(max_length=1, null=True, blank=True)
    ch_pass_usua2 = models.CharField(max_length=10, null=True, blank=True)

    class Meta:
        db_table = 'MAE_USUARIO'
        verbose_name = 'Usuario'

    def __str__(self):
        return f'{self.ch_codi_usuario} – {self.vc_desc_nomb_usuario}'


class MaePerfilMaeUsuario(models.Model):
    """
    Asignación de perfiles a usuarios (tabla intermedia M2M con datos extra).
    Relaciones:
      → MAE_PERFIL (ch_codi_perfil)
      → MAE_USUARIO (ch_codi_usuario)
    """
    ch_codi_usuario = models.ForeignKey(
        MaeUsuario,
        on_delete=models.PROTECT,
        db_column='CH_CODI_USUARIO',
        to_field='ch_codi_usuario',
        related_name='perfiles',
    )
    ch_codi_perfil = models.ForeignKey(
        MaePerfil,
        on_delete=models.PROTECT,
        db_column='CH_CODI_PERFIL',
        to_field='ch_codi_perfil',
        related_name='usuarios',
    )
    ch_nume_asigna = models.CharField(max_length=3)
    dt_fech_asigna = models.DateTimeField(null=True, blank=True)
    ch_codi_usua_asigna = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_revoca = models.DateTimeField(null=True, blank=True)
    ch_codi_usua_revoca = models.CharField(max_length=15, null=True, blank=True)
    ch_esta_perfil_usua = models.CharField(max_length=1, null=True, blank=True)

    class Meta:
        db_table = 'MAE_PERFIL_MAE_USUARIO'
        unique_together = [('ch_codi_usuario', 'ch_codi_perfil', 'ch_nume_asigna')]
        verbose_name = 'Perfil – Usuario'


# ---------------------------------------------------------------------------
# MAESTRAS OPERATIVAS
# ---------------------------------------------------------------------------

class MaeGarita(models.Model):
    """Garita / punto de control."""
    ch_codi_garita = models.CharField(max_length=3, primary_key=True)
    vc_desc_garita = models.CharField(max_length=50, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_GARITA'
        verbose_name = 'Garita'

    def __str__(self):
        return f'{self.ch_codi_garita} – {self.vc_desc_garita}'


class MaeGaritaXUsuario(models.Model):
    """
    Asignación de usuarios a garitas.
    Relaciones:
      → MAE_GARITA (ch_codi_garita)
      → MAE_USUARIO (ch_codi_usuario)
    """
    ch_codi_garita = models.ForeignKey(
        MaeGarita,
        on_delete=models.PROTECT,
        db_column='ch_codi_garita',
        to_field='ch_codi_garita',
        related_name='usuarios_garita',
    )
    ch_codi_usuario = models.ForeignKey(
        MaeUsuario,
        on_delete=models.PROTECT,
        db_column='ch_codi_usuario',
        to_field='ch_codi_usuario',
        related_name='garitas',
    )
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'mae_garita_x_usuario'
        unique_together = [('ch_codi_garita', 'ch_codi_usuario')]
        verbose_name = 'Garita × Usuario'


class MaeCliente(models.Model):
    """Cliente corporativo o particular."""
    ch_codi_cliente = models.CharField(max_length=4, primary_key=True)
    ch_ruc_cliente = models.CharField(max_length=11, null=True, blank=True)
    vc_razo_soci_cliente = models.CharField(max_length=100, null=True, blank=True)
    vc_dire_cliente = models.CharField(max_length=100, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    ch_esta_cliente_vip = models.BooleanField(null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_esta_tarifa_unica = models.CharField(max_length=1, null=True, blank=True)
    nu_impo_tarifa = models.DecimalField(max_digits=13, decimal_places=3, null=True, blank=True)

    class Meta:
        db_table = 'MAE_CLIENTE'
        verbose_name = 'Cliente'

    def __str__(self):
        return f'{self.ch_codi_cliente} – {self.vc_razo_soci_cliente}'


class MaeChofer(models.Model):
    """Conductor registrado."""
    ch_codi_chofer = models.CharField(max_length=4, primary_key=True)
    vc_desc_chofer = models.CharField(max_length=100, null=True, blank=True)
    ch_nume_celu = models.CharField(max_length=20, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    vc_dire_chofer = models.CharField(max_length=100, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_nume_dni = models.CharField(max_length=15, null=True, blank=True)

    class Meta:
        db_table = 'MAE_CHOFER'
        verbose_name = 'Chofer'

    def __str__(self):
        return f'{self.ch_codi_chofer} – {self.vc_desc_chofer}'


class MaeTipoVehiculo(models.Model):
    """Tipo / categoría de vehículo."""
    ch_tipo_vehiculo = models.CharField(max_length=2, primary_key=True)
    vc_desc_tipo_vehiculo = models.CharField(max_length=50, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_TIPO_VEHICULO'
        verbose_name = 'Tipo de Vehículo'

    def __str__(self):
        return f'{self.ch_tipo_vehiculo} – {self.vc_desc_tipo_vehiculo}'


class MaeVehiculo(models.Model):
    """
    Vehículo registrado.
    Relaciones:
      → MAE_TIPO_VEHICULO (ch_tipo_vehiculo)
      → MAE_CLIENTE       (ch_codi_cliente)
      → MAE_CHOFER        (ch_codi_chofer)
    """
    ch_codi_vehiculo = models.CharField(max_length=6, primary_key=True)
    ch_plac_vehiculo = models.CharField(max_length=20, null=True, blank=True)
    ch_tipo_vehiculo = models.ForeignKey(
        MaeTipoVehiculo,
        on_delete=models.PROTECT,
        db_column='CH_TIPO_VEHICULO',
        to_field='ch_tipo_vehiculo',
        null=True, blank=True,
        related_name='vehiculos',
    )
    ch_codi_cliente = models.ForeignKey(
        MaeCliente,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CLIENTE',
        to_field='ch_codi_cliente',
        null=True, blank=True,
        related_name='vehiculos',
    )
    ch_codi_chofer = models.ForeignKey(
        MaeChofer,
        on_delete=models.PROTECT,
        db_column='CH_CODI_CHOFER',
        to_field='ch_codi_chofer',
        null=True, blank=True,
        related_name='vehiculos',
    )
    nu_nume_llanta = models.IntegerField(null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_esta_parqueado = models.BooleanField(null=True, blank=True)
    nu_impo_alquiler = models.DecimalField(max_digits=12, decimal_places=3, null=True, blank=True)

    class Meta:
        db_table = 'MAE_VEHICULO'
        verbose_name = 'Vehículo'

    def __str__(self):
        return f'{self.ch_codi_vehiculo} – {self.ch_plac_vehiculo}'


class MaeTipoIncidente(models.Model):
    """Tipo de incidente registrable en tickets."""
    ch_codi_tipo_incidente = models.CharField(max_length=3, primary_key=True)
    vc_desc_tipo_incidente = models.CharField(max_length=50, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_TIPO_INCIDENTE'
        verbose_name = 'Tipo de Incidente'

    def __str__(self):
        return f'{self.ch_codi_tipo_incidente} – {self.vc_desc_tipo_incidente}'


class MaeTipoEgreso(models.Model):
    """Categoría de egreso de caja."""
    ch_codi_tipo_egreso = models.CharField(max_length=3, primary_key=True)
    vc_desc_tipo_egreso = models.CharField(max_length=50, null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_TIPO_EGRESO'
        verbose_name = 'Tipo de Egreso'

    def __str__(self):
        return f'{self.ch_codi_tipo_egreso} – {self.vc_desc_tipo_egreso}'


class MaeTipoIngreso(models.Model):
    """Categoría de ingreso de caja."""
    ch_codi_tipo_ingreso = models.CharField(max_length=3, primary_key=True)
    vc_desc_tipo_ingreso = models.CharField(max_length=50, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_TIPO_INGRESO'
        verbose_name = 'Tipo de Ingreso'

    def __str__(self):
        return f'{self.ch_codi_tipo_ingreso} – {self.vc_desc_tipo_ingreso}'


class MaeTipoDocumento(models.Model):
    """Tipo de documento fiscal/comercial (boleta, factura, etc.)."""
    ch_codi_tipo_dcmnt = models.CharField(max_length=2, primary_key=True)
    vc_desc_tipo_dcmnt = models.CharField(max_length=30, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_TIPO_DOCUMENTO'
        verbose_name = 'Tipo de Documento'

    def __str__(self):
        return f'{self.ch_codi_tipo_dcmnt} – {self.vc_desc_tipo_dcmnt}'


class MaeCorrelativo(models.Model):
    """
    Correlativos de series/números por tipo de documento.
    Relaciones:
      → MAE_TIPO_DOCUMENTO (ch_codi_tipo_dcmnt)
    """
    ch_codi_correlativo = models.CharField(max_length=4, primary_key=True)
    ch_codi_tipo_dcmnt = models.ForeignKey(
        MaeTipoDocumento,
        on_delete=models.PROTECT,
        db_column='CH_CODI_TIPO_DCMNT',
        to_field='ch_codi_tipo_dcmnt',
        null=True, blank=True,
        related_name='correlativos',
    )
    ch_seri_actual = models.CharField(max_length=4, null=True, blank=True)
    ch_nume_actual = models.CharField(max_length=10, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_CORRELATIVO'
        verbose_name = 'Correlativo'


class MaeProveedor(models.Model):
    """Proveedor para egresos de caja."""
    ch_codi_proveedor = models.CharField(max_length=4, primary_key=True)
    vc_razo_soci_prov = models.CharField(max_length=100, null=True, blank=True)
    ch_ruc_prov = models.CharField(max_length=11, null=True, blank=True)
    vc_dire_prov = models.CharField(max_length=100, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    ch_codi_usua_regi = models.CharField(max_length=15, null=True, blank=True)
    ch_codi_usua_modi = models.CharField(max_length=15, null=True, blank=True)
    dt_fech_usua_modi = models.DateTimeField(null=True, blank=True)
    dt_fech_usua_regi = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'MAE_PROVEEDOR'
        verbose_name = 'Proveedor'

    def __str__(self):
        return f'{self.ch_codi_proveedor} – {self.vc_razo_soci_prov}'


class MaeVariable(models.Model):
    """Variables de configuración del sistema."""
    ch_codi_variable = models.CharField(max_length=2, primary_key=True)
    vc_desc_variable = models.CharField(max_length=70, null=True, blank=True)
    nu_nume_valor = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    ch_esta_activo = models.BooleanField(null=True, blank=True)
    dt_fech_ulti_actu = models.DateTimeField(null=True, blank=True)
    ch_codi_usua = models.CharField(max_length=15, null=True, blank=True)
    ch_valo_variable = models.CharField(max_length=10, null=True, blank=True)
    nu_nume_valo_desde = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    nu_nume_valo_hasta = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    ch_nume_valo_desde = models.CharField(max_length=10, null=True, blank=True)
    ch_nume_valo_hasta = models.CharField(max_length=10, null=True, blank=True)

    class Meta:
        db_table = 'MAE_VARIABLE'
        verbose_name = 'Variable'
