/// The onboarding ATT prompt has been answered, whatever the answer.
///
/// [AttributionMiddleware] starts the ad attribution SDK held back on a first
/// launch, so the install it reports carries the IDFA the user just allowed.
class AttPermissionResolvedAction {
  const AttPermissionResolvedAction();
}
