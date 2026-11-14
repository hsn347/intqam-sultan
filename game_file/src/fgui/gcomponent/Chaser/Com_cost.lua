local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_cost = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/Com_cost", Com_cost)
function Com_cost:onInit()
	self.fields.Com_add:addClickListener(handler(self, self.onAddClick))
	self.fields.Com_rune:addClickListener(handler(self, self.onAddClick))
end
function Com_cost:onShow()
end
function Com_cost:initData(data, uid)
	self.data = data
	self.uid = uid
	if data.type == 1 then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_item:initData(data.id)
		local myCount = backpackCtrl:getItemCount(data.id)
		backpackCtrl = nil
		;(nil).var1 = fguiHelper.getColorString(myCount >= data.count and "#FFFFFF" or "#E02B2B", myCount)
		;(nil).var2 = data.count
		self.fields.Text_num:setString(i18n("%{var1}/%{var2}", nil))
	elseif data.type == 2 then
		self.controllers.c1:setSelectedIndex(1)
		local myCount = data.chooseNum or 0
		self.fields.Com_add:setVisible(myCount == 0)
		self.fields.Com_rune:setVisible(0 < myCount)
		if myCount == 0 then
			self.fields.Com_add:setTouchEnabled(true)
			self.fields.Com_rune:setTouchEnabled(false)
		else
			self.fields.Com_add:setTouchEnabled(false)
			self.fields.Com_rune:setTouchEnabled(true)
			backpackCtrl = true
			;(true).rid = data.id
			self.fields.Com_rune:initData(true)
		end
		backpackCtrl = i18n("%{var1}/%{var2}", nil)
		i18n("%{var1}/%{var2}", nil).var1 = fguiHelper.getColorString(myCount >= data.count and "#FFFFFF" or "#E02B2B", myCount)
		i18n("%{var1}/%{var2}", nil).var2 = data.count
		self.fields.Text_num:setString(i18n("%{var1}/%{var2}", i18n("%{var1}/%{var2}", nil)))
	end
end
function Com_cost:onAddClick()
	SoraDPlaySound()
	local ret = false
	local runeList = godArmsRuneCtrl:getRuneData()
	for k, v in ipairs(runeList) do
		if not v.isLock and v.uid ~= self.uid and not godArmsRuneCtrl:isRuneWear(v.uid) and v.rid == self.data.id then
			ret = true
			break
		end
	end
	if ret then
		_ENV = nil
		;(nil).data = self.data
		;(nil).uid = self.uid
		uiManager:show("RuneChooseView", nil)
	else
		SoraDShowMsgTip(i18n("Weapon_Rune_tips_046"))
	end
end
return Com_cost
