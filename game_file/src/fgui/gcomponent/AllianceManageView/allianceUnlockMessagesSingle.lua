local allianceDesRead = include("allianceDesRead")
local allianceMsg = SoraDGetCtrl("allianceMsg")
local baseComponent = require("fgui.base.baseComponent")
local allianceUnlockMessagesSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/allianceUnlockMessagesSingle", allianceUnlockMessagesSingle)
function allianceUnlockMessagesSingle:onInit()
	self.fields.Button_unlock:setString(i18n("common_text_077"))
	self.fields.Button_unlock:addClickListener(handler(self, self.btnClickCallBack))
	self:fixChildrenPos()
end
function allianceUnlockMessagesSingle:onShow()
end
function allianceUnlockMessagesSingle:initData(data, tag)
	self.singleData = data
	self.tag = tag
	if self.tag == 1 then
		self.fields.Com_head:setVisible(true)
		self.fields.Node_flag:setVisible(false)
		self.fields.Com_head:setHeadSprite(self.singleData.iconID, self.singleData.avatar)
		self.fields.Com_head:setPlayerID(self.singleData.uid)
		if self.singleData.abbr then
			_ENV = nil
			;(nil).abbr = self.singleData.abbr
			;(nil).name = self.singleData.nickName
			self.fields.Text_name:setString(i18n("common_text_186", nil))
		else
			self.fields.Text_name:setString(self.singleData.nickName)
		end
	else
		self.fields.Com_head:setVisible(false)
		self.fields.Node_flag:setVisible(true)
		local flagNode = allianceDesRead.getFlagNode(self.singleData.flag)
		flagNode:setScale(0.5)
		flagNode:setPosition(5, 5)
		self.fields.Node_flag:clearContent()
		self.fields.Node_flag:setContent(flagNode)
		self.fields.Text_name:setString(self.singleData.aname)
	end
end
function allianceUnlockMessagesSingle:btnClickCallBack()
	SoraDPlaySound()
	if self.tag == 1 then
		_ENV = nil
		;(nil).uid = self.singleData.uid
		allianceMsg:reqOperateShieldList(gAShieldListOperate.del, nil)
	else
		_ENV = nil
		;(nil).aid = self.singleData.aid
		allianceMsg:reqOperateShieldList(gAShieldListOperate.del, nil)
	end
end
return allianceUnlockMessagesSingle
