local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaOfflcer/Com_list", Com_list)
local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
local nebulaPrivilegeCtrl = SoraDGetCtrl("nebulaPrivilegeCtrl")
function Com_list:onInit()
	self.fields.Btn_reward:addClickEventListener(handler(self, self.btnGiftClick))
	self.fields.Btn_reward:setTitle(i18n("common_text_1441"))
	self.fields.txtOfficer:setAlign(cc.TEXT_ALIGNMENT_LEFT)
	self.fields.Text_Name:setAlign(cc.TEXT_ALIGNMENT_RIGHT)
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_list:onShow()
end
function Com_list:initData(cfg)
	self.cfg = cfg
	self.rewards = self.cfg.rewards
	self.fields.List_reward:setNumItems(#self.rewards)
	local officerName = nebulaPrivilegelRead.getOfficialName(cfg.appointID)
	if officerName then
		nebulaPrivilegelRead = nil
		;(nil).officer = i18n(officerName)
		self.fields.txtOfficer:setString(i18n("nebula_officer_text_002", nil))
	end
	self.fields.Text_Name:setString(i18n(cfg.name))
	fguiHelper.setTextWidthHeight(self.fields.Text_Name, cc.size(220, 40))
	self.fields.Btn_reward:setVisible(nebulaPrivilegeCtrl:isKing(cfg.appointID))
	local textNum = self.fields.Text_Num
	local sendNum = nebulaPrivilegeCtrl:getGiftSendNum(cfg.treasureID)
	local leftNum = cfg.count - sendNum
	nebulaPrivilegelRead = nebulaPrivilegeCtrl:isKing(cfg.appointID)
	nebulaPrivilegeCtrl:isKing(cfg.appointID).var1 = fguiHelper.getColorString(leftNum == 0 and "#FF0000" or "#FFD246", leftNum)
	nebulaPrivilegeCtrl:isKing(cfg.appointID).var2 = cfg.count
	textNum:setString(i18n("(%{var1}/%{var2})", nebulaPrivilegeCtrl:isKing(cfg.appointID)))
	if leftNum <= 0 then
		self.fields.Btn_reward:setBright(false)
		self.fields.Btn_reward:setTouchEnabled(false)
	end
	self.fields.Btn_reward:setReddot(0 < leftNum)
end
function Com_list:btnGiftClick()
	SoraDPlaySound()
	local panel = SoraDCreatePanel("worldMapKingdomCityAppointSelect")
	panel:setNebulaGift(self.cfg.treasureID, nebulaPrivilegeCtrl:getLimitUser(), nebulaPrivilegeCtrl:getKindomList())
	panel:show()
end
function Com_list:onItemRenderer(index, obj)
	local item = self.rewards[index + 1]
	obj:initData(item.id, item.count)
end
return Com_list
