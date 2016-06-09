#########################################################################
#
#                                                Secure OS
#
#########################################################################
ifeq ($(TARGET_USE_SECUREOS),true)
PRODUCT_PACKAGES += otz_client \
	secure_ta \
	libotzapi \
	otz_echo_client \
	otz_crypto_client

endif
