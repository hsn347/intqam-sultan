local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_managerSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameWar/Com_managerSingle", Com_managerSingle)
function Com_managerSingle:onInit()
	self.fields.Button_change:setString(i18n("common_text_243"))
	self.fields.Button_change:addClickListener(handler(self, self.onClickBtnChange))
end
function Com_managerSingle:onShow()
end
function Com_managerSingle:onClickBtnChange(...)
	SoraDPlaySound()
	if not roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.MODIFY_MANAGER, true) then
		return
	end
	local layer = uiManager:show("LordSelectView").view
	_ENV = nil
	;(nil).title = i18n("atlantiswar_text_0030")
	;(nil).castleLvLimit = ATLANTIS_WAR_CASTLE_LEVEL
	;(nil).limitTips = "flames_dunes_text212"
	;(nil).shieldUidMap = self.shieldUidMap
	;(nil).handle = function(tableUID)
		roaringFlameWarCtrl:reqModifyManager(self.index, tableUID[1])
	end
	;(nil).warType = gKingdomClassType.roaringFlame
	layer:setStyleAtlantisManager(nil)
end
function Com_managerSingle:initData(data, otherData)
	self.index = otherData.index
	self.shieldUidMap = otherData.shieldUidMap
	self.fields.Com_memberSingle:initData(data)
	self.fields.Button_change:setVisible(roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.MODIFY_MANAGER))
end
return Com_managerSingle
