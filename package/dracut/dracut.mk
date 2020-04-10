################################################################################
#
# dracut
#
################################################################################

DRACUT_VERSION = 050
DRACUT_SITE = $(call github,dracutdevs,dracut,$(DRACUT_VERSION))
DRACUT_LICENSE = GPL-2.0
DRACUT_LICENSE_FILES = COPYING

# Dracut requires realpath from coreutils
HOST_DRACUT_DEPENDENCIES += \
	host-pkgconf \
	host-kmod \
	host-coreutils \
	host-findutils \
	host-cpio \
	host-gzip \
	host-util-linux \
	host-prelink-cross

DRACUT_DEPENDENCIES += \
	host-dracut \
	bash \
	bash-completion \
	pkgconf \
	kmod \
	bash-completion

DRACUT_MAKE_ENV += \
	CC="$(TARGET_CC)" \
	PKG_CONFIG="$(HOST_PKG_CONFIG_PATH)"

DRACUT_CONF_OPTS = --disable-documentation

HOST_DRACUT_MAKE_ENV += \
	PKG_CONFIG="$(HOST_PKG_CONFIG_PATH)"

HOST_DRACUT_CONF_OPTS = --disable-documentation

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
DRACUT_DEPENDENCIES += systemd
DRACUT_CONF_OPTS += --systemdsystemunitdir=/usr/lib/systemd/system
endif

define DRACUT_REMOVE_UNEEDED_FILES
	$(RM) -r $(TARGET_DIR)/usr/lib/dracut/modules.d/00bootchart
	$(RM) -r $(TARGET_DIR)/usr/lib/dracut/modules.d/50gensplash
	$(RM) -r $(TARGET_DIR)/usr/lib/dracut/modules.d/96securityfs
	$(RM) -r $(TARGET_DIR)/usr/lib/dracut/modules.d/97masterkey
	$(RM) -r $(TARGET_DIR)/usr/lib/dracut/modules.d/98integrity
	# Do not start dracut services normally. Dracut will enable these services
	# when building an image.
	find $(TARGET_DIR)/etc/systemd/system -name "*dracut*.service" -delete
endef
DRACUT_TARGET_FINALIZE_HOOKS += DRACUT_REMOVE_UNEEDED_FILES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
