package com.bmwgroup.connected.internal.security;

// BMW Connected Classic registers this under Intent("com.bmwgroup.connected.bmw.usa.SECURITY_SERVICE").setPackage("com.bmwgroup.connected.bmw.usa")
// BMW Connected registers this under Intent("de.bmw.connected.SECURITY_SERVICE")
// BMW Connected (NA) registers this under Intent("de.bmw.connected.na.SECURITY_SERVICE")
// MINI Connected Classic registers this under Intent("com.bmwgroup.connected.mini.usa.SECURITY_SERVICE")
// MINI Connected registers this under Intent("de.mini.connected.SECURITY_SERVICE")
// MINI Connected (NA) registers this under Intent("de.mini.connected.na.SECURITY_SERVICE")

interface ICarSecurityService {
    /**
     * Prepares a Security Authentication session
     *
     * @param packageName, for example getApplicationContext().getPackageName()
     * @param appName, for example "lastmile"
     * @return Handle to a security context
     */
    long createSecurityContext(String packageName, String appName);

    /**
     * Cleans up the security context
     *
     * @param contextHandle Handle to a security context to cleanup
     */
    void releaseSecurityContext(long contextHandle);

    /**
     * Returns the cert bundle for this application, from the given context
     * Suitable for sending directly to sas_certificate()
     *
     * @param contextHandle The handle from createSecurityContext
     * @return The cert that this app should present to the Car
     */
    byte[] loadAppCert(long contextHandle);

    /**
     * Signs the challenge given by the car, to be used in sas_login()
     */
    byte[] signChallenge(long contextHandle, in byte[] challenge);
}

