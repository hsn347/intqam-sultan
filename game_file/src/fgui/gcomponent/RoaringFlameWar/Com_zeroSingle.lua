local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_zeroSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameWar/Com_zeroSingle", Com_zeroSingle)
function Com_zeroSingle:onInit()
	self.fields.Button_change:setString(i18n("common_text_3889"))
	self.fields.Button_change:addClickListener(handler(self, self.onClickBtnChange))
	self.fields.Button_back:setString(i18n("flames_dunes_text251"))
	self.fields.Button_back:addClickListener(handler(self, self.onClickBtnBack))
	self.fields.Button_kick:setString(i18n("flames_dunes_text351"))
	self.fields.Button_kick:addClickListener(handler(self, self.onClickBtnKick))
end
function Com_zeroSingle:onShow()
end
function Com_zeroSingle:onClickBtnChange(...)
	SoraDPlaySound()
	if not roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.MODIFY_LV0_USER, true) then
		return
	end
	roaringFlameWarCtrl:reqRemoveLv0User(self.data.uid)
end
function Com_zeroSingle:onClickBtnBack(...)
	SoraDPlaySound()
	if not roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.MODIFY_LV0_USER, true) then
		return
	end
	local roaringFlameWarRead = include("roaringFlameWarRead")
	local timeCD = roaringFlameWarRead.getConstValue("FLAMES_DUNES_REPATRIATE_TIME", 120)
	local time = math.ceil(timeCD / 60)
	_ENV = nil
	;(nil).name = self.data.nickName
	;(nil).time = time
	local msgStr = i18n("flames_dunes_text247", nil)
	local uid = self.data.uid
	SoraDShowMsgBox(msgStr, nil, nil, function(exitType)
		if exitType == MSGBOX_CALLBACK_YES then
			roaringFlameWarCtrl:reqBackPlayer(uid)
		end
	end)
end
function Com_zeroSingle:onClickBtnKick(...)
	SoraDPlaySound()
	if not roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.KICK_LV0_USER, true) then
		return
	end
	_ENV = true
	;(true).name = self.data.nickName
	local msgStr = i18n("flames_dunes_text357", true)
	_ENV = self.data.nickName
	self.data.nickName.color = "#FF0000"
	msgStr = SoraDWrapHtmlTagByStyle(msgStr, self.data.nickName)
	local uid = self.data.uid
	SoraDShowMsgBox(msgStr, i18n("common_text_204"), i18n("common_text_185"), function(exitType)
		if exitType == MSGBOX_CALLBACK_YES then
			roaringFlameWarCtrl:reqKickPlayer(uid)
		end
	end)
end
function Com_zeroSingle:initData(data, param)
	self.data = data
	self.fields.Com_memberSingle:initData(data, param)
	self.isKick = param and param.isKick or false
	self.controllers.c1:setSelectedIndex(self.isKick and 1 or 0)
end
return Com_zeroSingle
