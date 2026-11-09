/// Proveedores de acceso externo mostrados en el login (SCR-02).
enum SsoProvider {
  google('Google'),
  apple('Apple'),
  github('GitHub');

  const SsoProvider(this.label);

  final String label;
}
