# Política de Privacidad — La Vida en Directo

**Última actualización:** [FECHA DE PUBLICACIÓN]  
**Versión:** 1.0

---

## 1. Responsable del tratamiento

| Campo | Datos |
|-------|-------|
| **Nombre / Razón social** | [TU NOMBRE O NOMBRE DE EMPRESA] |
| **CIF / NIF** | [TU NIF/CIF] |
| **Dirección** | [DIRECCIÓN COMPLETA] |
| **Email de contacto** | [TU EMAIL DE CONTACTO] |
| **Email de privacidad** | privacidad@[tudominio].com |

---

## 2. ¿Qué datos recogemos y para qué?

### 2.1 Datos de registro

| Dato | Finalidad | Base legal |
|------|-----------|------------|
| Nombre | Identificación en la app | Ejecución del contrato (art. 6.1.b RGPD) |
| Correo electrónico | Autenticación, recuperación de contraseña | Ejecución del contrato |
| Contraseña (hashed con bcrypt) | Autenticación segura | Ejecución del contrato |

### 2.2 Contenido generado por el usuario

| Dato | Finalidad | Base legal |
|------|-----------|------------|
| Conciertos (artista, fecha, lugar, valoraciones) | Funcionalidad principal de la app | Ejecución del contrato |
| Fotos de conciertos | Álbum personal de recuerdos | Ejecución del contrato |
| Comentarios en conciertos de amigos | Función social | Ejecución del contrato |
| Lista "quiero ir" | Recordatorio de próximos eventos | Ejecución del contrato |

### 2.3 Datos sociales

| Dato | Finalidad | Base legal |
|------|-----------|------------|
| Relaciones de amistad | Función social (feed de amigos, etiquetado) | Ejecución del contrato |
| Etiquetados en conciertos y fotos | Compartir experiencias | Consentimiento del usuario etiquetado |

### 2.4 Datos técnicos

| Dato | Finalidad | Base legal |
|------|-----------|------------|
| Token FCM del dispositivo | Notificaciones push | Interés legítimo / consentimiento |
| Dirección IP (logs de servidor) | Seguridad, detección de fraude | Interés legítimo (art. 6.1.f RGPD) |
| Foto de perfil (avatar) | Identificación visual | Ejecución del contrato |

---

## 3. ¿Con quién compartimos tus datos?

Trabajamos con los siguientes **encargados del tratamiento** (terceros que procesan datos en nuestro nombre):

| Proveedor | País | Servicio | Garantías |
|-----------|------|---------|-----------|
| **Neon Tech** | EE. UU. | Base de datos PostgreSQL | SCCs UE-EE.UU. + DPA |
| **Cloudinary** | EE. UU. | Almacenamiento de imágenes | SCCs + DPA |
| **Render** | EE. UU. | Servidor de aplicación | SCCs + DPA |
| **Google Firebase** | EE. UU. | Notificaciones push (FCM) | SCCs + DPA |
| **Spotify AB** | Suecia | Información de artistas (API pública) | No se transfieren datos de usuario |
| **Ticketmaster** | EE. UU. | Recomendaciones de eventos (API pública) | No se transfieren datos de usuario |
| **Setlist.fm** | — | Setlists de conciertos (API pública) | No se transfieren datos de usuario |

No vendemos tus datos a terceros ni los cedemos con fines publicitarios.

---

## 4. Transferencias internacionales de datos

Algunos proveedores están ubicados fuera del Espacio Económico Europeo (EE. UU.). Las transferencias se realizan con las garantías adecuadas establecidas en el art. 46 RGPD (Cláusulas Contractuales Estándar adoptadas por la Comisión Europea).

---

## 5. ¿Cuánto tiempo conservamos tus datos?

| Tipo de dato | Plazo de conservación |
|-------------|----------------------|
| Datos de cuenta | Hasta que eliminas tu cuenta |
| Conciertos y fotos | Hasta que eliminas tu cuenta |
| Logs de servidor (IPs) | 90 días |
| Tokens FCM | Hasta que cierras sesión o desinstalas la app |
| Datos tras eliminación de cuenta | 30 días (copia de seguridad), luego borrado definitivo |

---

## 6. Tus derechos

Bajo el RGPD y la LOPD-GDD tienes derecho a:

- **Acceso**: saber qué datos tenemos sobre ti.
- **Rectificación**: corregir datos inexactos.
- **Supresión** ("derecho al olvido"): eliminar tus datos.
- **Limitación del tratamiento**: restringir el uso de tus datos.
- **Portabilidad**: recibir tus datos en formato estructurado.
- **Oposición**: oponerte al tratamiento basado en interés legítimo.
- **Retirada del consentimiento**: cuando el tratamiento se basa en él.

Para ejercer cualquiera de estos derechos, escríbenos a **privacidad@[tudominio].com** indicando tu nombre, email de registro y el derecho que deseas ejercer. Responderemos en el plazo máximo de **un mes** (ampliable dos meses más en casos complejos).

Si consideras que el tratamiento no es conforme al RGPD, puedes presentar una reclamación ante la **Agencia Española de Protección de Datos (AEPD)**: [https://www.aepd.es](https://www.aepd.es)

---

## 7. Seguridad de los datos

Aplicamos medidas técnicas y organizativas adecuadas para proteger tus datos:

- Contraseñas almacenadas con **bcrypt** (hashing unidireccional, nunca en texto plano).
- Comunicaciones cifradas mediante **HTTPS/TLS**.
- Acceso a la base de datos restringido por roles y red privada.
- Tokens JWT con expiración de 7 días e invalidación automática tras cambio de contraseña.
- Cabeceras de seguridad HTTP (Helmet): CSP, HSTS, X-Frame-Options, etc.
- Límite de intentos de inicio de sesión (rate limiting) para prevenir ataques de fuerza bruta.

---

## 8. Menores de edad

Esta aplicación **no está dirigida a menores de 14 años** (edad mínima legal en España para dar consentimiento digital). Si eres menor de 14 años, necesitas el consentimiento de tu padre, madre o tutor/a legal para usar la app.

Si detectamos que hemos recogido datos de un menor sin consentimiento parental, los eliminaremos de inmediato. Contacta con nosotros en privacidad@[tudominio].com.

---

## 9. Cookies y tecnologías de seguimiento

La aplicación móvil **no utiliza cookies**. El servidor puede registrar IPs temporalmente en logs de sistema por motivos de seguridad (ver sección 5).

---

## 10. Contenido de terceros

La app muestra datos de:

- **Spotify**: información de artistas e información sobre sus canciones populares. Los datos se obtienen mediante la API oficial de Spotify y están sujetos a sus [Términos de Uso](https://developer.spotify.com/terms).
- **Ticketmaster**: recomendaciones de eventos en vivo. Datos obtenidos mediante la API oficial y sujetos a sus [Términos de Uso](https://developer.ticketmaster.com/support/terms-of-use/).
- **Setlist.fm**: setlists de conciertos. Datos obtenidos mediante la API oficial y sujetos a sus [Términos de Uso](https://api.setlist.fm/docs/1.0/index.html).

Ninguna de estas integraciones transmite datos personales del usuario a dichos terceros.

---

## 11. Eliminación de cuenta

Puedes eliminar tu cuenta desde **Ajustes → Eliminar cuenta** en la app. La eliminación borra permanentemente:

- Tu perfil y datos de registro.
- Todos tus conciertos y fotos.
- Tus relaciones de amistad.
- Tus notificaciones.

El proceso es irreversible. Tus datos se borran de forma definitiva tras el período de retención en copia de seguridad (30 días).

---

## 12. Cambios en esta política

Si realizamos cambios materiales en esta política, te notificaremos mediante una notificación push o un aviso dentro de la app, con al menos **15 días de antelación** antes de que entren en vigor. El uso continuado de la app tras esa fecha implica la aceptación de los cambios.

---

## 13. Contacto

Para cualquier consulta sobre privacidad:

📧 **privacidad@[tudominio].com**  
📮 [DIRECCIÓN POSTAL]  
[CIUDAD, CÓDIGO POSTAL, PAÍS]

---

*Esta política de privacidad se ha redactado conforme al Reglamento (UE) 2016/679 (RGPD) y la Ley Orgánica 3/2018, de 5 de diciembre, de Protección de Datos Personales y garantía de los derechos digitales (LOPD-GDD).*
