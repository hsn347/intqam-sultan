local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local magicLampSkillRead = include("magicLampSkillRead")
local buffDesRead = include("buffDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_skillBig = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampSkill/Com_skillBig", Com_skillBig)
function Com_skillBig:onInit()
	self.data, _ENV, self.viewType = nil, nil, 0
	self.fields.Button_rebirth:setString(i18n("Weapon_Rune_tips_078"))
	self.fields.Button_rebirth:addClickListener(handler(self, self.onClickBtnRebirth))
	self.fields.Button_lock:addClickListener(handler(self, self.onClickBtnLock))
	self.fields.Button_upgrade:setString(i18n("common_text_055"))
	self.fields.Button_upgrade:addClickListener(handler(self, self.onClickBtnUpgrade))
	self.fields.Button_advance:setString(i18n("common_text_2921"))
	self.fields.Button_advance:addClickListener(handler(self, self.onClickBtnAdvance))
	self.fields.Button_merge:addClickListener(handler(self, self.onClickBtnMerge))
	self.fields.Text_get:setString(i18n("jinn_skill_62"))
	self.fields.Text_get:setVisible(false)
	self.fields.Text_upgrade:setVisible(false)
	self.fields.Text_advance:setVisible(false)
	if not SoraDFIsRA() then
		self.fields.Button_rebirth:fixPos()
		self.fields.Button_lock:fixPos()
	end
end
function Com_skillBig:onShow()
end
function Com_skillBig:onClickBtnRebirth(...)
	SoraDPlaySound()
	if magicLampCtrl:getIsUsing(self.data.id) then
		SoraDShowMsgTip(i18n("jinn_skill_9"))
		return
	end
	if self.data.lv <= 1 and self.data.classLv <= 0 then
		SoraDShowMsgTip(i18n("jinn_skill_10"))
		return
	end
	_ENV = i18n("jinn_skill_10")
	i18n("jinn_skill_10").data = self.data
	uiManager:show("MagicLampSkillRebirth", i18n("jinn_skill_10"))
end
function Com_skillBig:onClickBtnLock(...)
	SoraDPlaySound()
	if self.data.lock then
		SoraDCheckSecondaryLock(function()
			magicLampSkillCtrl:reqLock(self.data.id, false)
			SoraDShowLoading(self:getParent():displayObject())
		end, gSecondaryLockType.MagicLampSkillUnlock, "MagicLampSkillDetails")
	else
		SoraDIsNeedOpenVerifySecondaryLock(function()
			local dailyRemindManager = include("dailyRemindManager")
			if not dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.magiclampskill_lock) then
				magicLampSkillCtrl:reqLock(self.data.id, true)
				SoraDShowLoading(self:getParent():displayObject())
				return
			end
			magicLampSkillCtrl = self:getParent():displayObject()
			self:getParent():displayObject().content = i18n(userSDKManager.isNeedVerify() and "Safety_lock_text_24" or "jinn_skill_67")
			self:getParent():displayObject().confirmFunc = function()
				if not tolua.isnull(self) then
					magicLampSkillCtrl:reqLock(self.data.id, true)
					SoraDShowLoading(self:getParent():displayObject())
				end
			end
			self:getParent():displayObject().remindString = i18n("coffeeCraftsman_text_27")
			self:getParent():displayObject().remindFunc = function(value)
				if value then
					dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.magiclampskill_lock)
				end
			end
			self:getParent():displayObject()[1] = i18n("common_text_204")
			uiManager:show("MessageBox", self:getParent():displayObject())
		end)
	end
end
function Com_skillBig:onClickBtnUpgrade(...)
	SoraDPlaySound()
	if magicLampSkillCtrl:checkCanUpgradeLv(self.data, true) then
		_ENV = true
		;(true).data = self.data
		uiManager:show("MagicLampSkillUpgrade", true)
	end
end
function Com_skillBig:onClickBtnAdvance(...)
	SoraDPlaySound()
	if magicLampSkillCtrl:checkCanUpgradeClass(self.data, true) then
		_ENV = true
		;(true).data = self.data
		uiManager:show("MagicLampSkillAdvance", true)
	end
end
function Com_skillBig:onClickBtnMerge(...)
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.needItem.id) >= self.needItem.count then
		_ENV = nil
		;(nil).itemID = self.needItem.id
		uiManager:show("MagicLampSkillMerge", nil)
	else
		SoraDRemoveAllPanelFromManager()
		uiManager:show("MagicLampMaigcPowerMain")
	end
end
function Com_skillBig:initData(data)
	self.data = data
	magicLampSkillCtrl:initSkillBase(self.fields, data)
	local quality = magicLampSkillRead.getSkillQuality(data.skillType)
	self.fields.Load_bg:setURL(magicLampSkillRead.getQualityFrameBig(quality))
	self:updateBtnLock()
	self.fields.Com_skillDetail:initData(self.data)
	if self.viewType == 1 then
		self:updateHandbookView()
	end
	if self.data.lv and self.data.classLv then
		local lvMax = magicLampSkillRead.getSkillLvMax(self.data.skillType)
		if lvMax == 1 then
			self.fields.Button_upgrade:setVisible(false)
		else
			self.fields.Button_upgrade:setVisible(true)
			self:updateUpgradeLvLimit()
		end
		local classLvMax = magicLampSkillRead.getSkillStageMax(self.data.skillType)
		if classLvMax == 0 then
			self.fields.Button_advance:setVisible(false)
		else
			self.fields.Button_advance:setVisible(true)
			self:updateUpgradeClassLimit()
		end
	end
	local stageGroup = magicLampSkillRead.getSkillStageGroup(self.data.skillType)
	local needItems = magicLampSkillRead.getRebirthNeed(stageGroup, 0)
	if #needItems == 0 then
		self.fields.Button_rebirth:setVisible(false)
	else
		self.fields.Button_rebirth:setVisible(true)
	end
end
function Com_skillBig:updateUpgradeLimit(...)
	self:updateUpgradeLvLimit()
	self:updateUpgradeClassLimit()
end
function Com_skillBig:updateUpgradeLvLimit(...)
	self.fields.Text_upgrade:setVisible(false)
	local ok, err = magicLampSkillCtrl:checkCanUpgradeLv(self.data)
	if err and err == 2 then
		local classLv = self.data.classLv or 0
		magicLampSkillCtrl = nil
		;(nil).lv = classLv + 1
		self.fields.Text_upgrade:setString(i18n("jinn_skill_15", nil))
		self.fields.Text_upgrade:setVisible(true)
	end
	if err and err == 1 then
		self.fields.Button_upgrade:setString(i18n("common_text_283"))
		self.fields.Button_upgrade:setBright(false)
	else
		self.fields.Button_upgrade:setString(i18n("common_text_055"))
		self.fields.Button_upgrade:setBright(true)
	end
end
function Com_skillBig:updateUpgradeClassLimit(...)
	self.fields.Text_advance:setVisible(false)
	local ok, err = magicLampSkillCtrl:checkCanUpgradeClass(self.data)
	if err and err == 2 then
		local stageGroup = magicLampSkillRead.getSkillStageGroup(self.data.skillType)
		local classLv = self.data.classLv or 0
		local needLv = magicLampSkillRead.getStageNeedLv(stageGroup, classLv + 1)
		magicLampSkillCtrl = nil
		;(nil).lv = needLv
		self.fields.Text_advance:setString(i18n("jinn_skill_18", nil))
		self.fields.Text_advance:setVisible(true)
	end
	if err and err == 1 then
		self.fields.Button_advance:setString(i18n("jinn_skill_79"))
		self.fields.Button_advance:setBright(false)
	else
		self.fields.Button_advance:setString(i18n("common_text_2921"))
		self.fields.Button_advance:setBright(true)
	end
end
function Com_skillBig:updateBtnLock(...)
	if self.data.lock then
		self.fields.Button_lock:setString(i18n("atlantiswar_bossskill_name_003"))
		self.fields.Button_lock:setIcon("icon_lock_gold.png")
	else
		self.fields.Button_lock:setString(i18n("jinn_skill_70"))
		self.fields.Button_lock:setIcon("icon_lock_unlock.png")
	end
end
function Com_skillBig:updateSkillLv(...)
	self.data = magicLampSkillCtrl:getSkillData(self.data.id)
	magicLampSkillCtrl = nil
	;(nil).lv = self.data.lv or 1
	self.fields.Text_lv:setString(i18n("common_text_100", nil))
	self.fields.Com_skillDetail:updateSkillLv(self.data)
	self:updateUpgradeLimit()
end
function Com_skillBig:updateSkillClassLv(...)
	self.data = magicLampSkillCtrl:getSkillData(self.data.id)
	self.fields.Com_star:updateStar(self.data.classLv or 0)
	self.fields.Com_skillDetail:updateSkillClassLv(self.data)
	self:updateUpgradeLimit()
end
function Com_skillBig:updateSkillLock(...)
	self.data = magicLampSkillCtrl:getSkillData(self.data.id)
	self:updateBtnLock()
end
function Com_skillBig:setViewType(viewType)
	self.viewType = viewType
	self.controllers.c_viewType:setSelectedIndex(viewType)
end
function Com_skillBig:updateHandbookView(...)
	local needItems = magicLampSkillRead.getSkillCompound(self.data.skillType)
	self.needItem = needItems[1]
	self:updateItemCount()
	self.fields.Load_item:setURL(publicRead.getIcon(self.needItem.id))
	self:updateGetState(magicLampSkillCtrl:checkHasSkill(self.data.skillType))
end
function Com_skillBig:updateItemCount(...)
	local itemID = self.needItem.id
	local itemCount = backpackCtrl:getItemCount(itemID)
	backpackCtrl = backpackCtrl
	backpackCtrl.member = itemCount
	local backpackCtrl.total, _data = self.needItem.count, backpackCtrl
	local countStr = i18n("common_text_155", _data)
	if itemCount < self.needItem.count then
		backpackCtrl, backpackCtrl = nil, nil
		;(nil).member, (nil).color = nil, "#FF0000"
		countStr = i18n_html("common_text_155", _data, nil)
		self.fields.Button_merge:setString(i18n("starlight_btn_01"))
	else
		self.fields.Button_merge:setString(i18n("common_text_1352"))
	end
	local itemName = publicRead.getName(itemID)
	backpackCtrl = i18n("common_text_1352")
	i18n("common_text_1352").name = itemName
	i18n("common_text_1352").msg = countStr
	self.fields.Text_item:setString(i18n("common_text_1000", i18n("common_text_1352")))
	fguiHelper.setTextWidthHeight(self.fields.Text_item, cc.size(380, 30))
end
function Com_skillBig:updateGetState(isGet)
	if not isGet then
		self.fields.Load_icon:setColor(cc.c3b(100, 100, 100))
		self.fields.Text_get:setVisible(true)
	else
		self.fields.Load_icon:setColor(cc.c3b(255, 255, 255))
		self.fields.Text_get:setVisible(false)
	end
end
function Com_skillBig:updateLookView(...)
	self.fields.Button_rebirth:setVisible(false)
	self.fields.Button_lock:setVisible(false)
	self.fields.Button_upgrade:setVisible(false)
	self.fields.Button_advance:setVisible(false)
	self.fields.Text_upgrade:setVisible(false)
	self.fields.Text_advance:setVisible(false)
end
return Com_skillBig
