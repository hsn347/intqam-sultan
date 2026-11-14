local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local publicRead = include("publicRead")
local heroBiographyCtrl = SoraDGetCtrl("heroBiographyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local newHeroUskillStudyView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/newHeroUskillStudyView", newHeroUskillStudyView)
function newHeroUskillStudyView:onInit()
	fguiHelper.SoraDSetComFields(self)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.com_progress:setVisible(false)
	_ENV, _ENV = self.fields.com_progress, self.fields.com_progress.setVisible
	self.fields.com_progress.activityID = gActivityTimeActivityID.HERO_AWAKE_ACTIVTY
	self.fields.com_progress.name = "activity_name_9001303"
	self.fields.com_progress.desc = "addition_text_01"
	self.fields.com_progress.icon = "icon_JJJC_huodong.png"
	self.fields.com_progress.btnName = "Button_lwjc"
	_ENV, self.fields.com_progress.setVisible[1], self.fields.com_progress.control = self.fields.com_progress, self.fields.com_progress, 0
	self.fields.com_progress.activityID = gActivityTimeActivityID.HERO_AWAKE_CRIT_ACTIVTY
	self.fields.com_progress.name = "activity_name_9001365"
	self.fields.com_progress.desc = "addition_text_02"
	self.fields.com_progress.icon = "icon_jjbj_huodong.png"
	self.fields.com_progress.btnName = "Button_lwbj"
	_ENV, self.fields.com_progress.setVisible[2], self.fields.com_progress.control = self.fields.com_progress, self.fields.com_progress, 1
	self.fields.com_progress.activityID = gActivityTimeActivityID.HERO_ADVANCE_SKILL_CRIT_ACTIVITY
	self.fields.com_progress.name = "activity_name_9001398"
	self.fields.com_progress.desc = "awakeSkillCrit_text_01"
	self.fields.com_progress.icon = "icon_jjbj_huodong.png"
	self.fields.com_progress.btnName = "Button_zjbj"
	self.activities, self.fields.com_progress.setVisible[3], self.fields.com_progress.control = self.fields.com_progress.setVisible, self.fields.com_progress, 2
end
function newHeroUskillStudyView:onShow()
end
function newHeroUskillStudyView:onItemRenderer(index, obj)
	obj:initData(self.heroID, self.skillList[index + 1], self.powerSkillBack, self:checkIsAllMax())
end
function newHeroUskillStudyView:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_AWAKE", handler(self, self.refresh))
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.recevieItemChangeMsg))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_FEED_SKILL", handler(self, self.refreshSillEXP))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeActivity))
	if not IsArClient then
		SoraDAddMessage(self, "MESSAGE_SERVER_HERO_AWAKE_FOR_ROS", handler(self, self.remakePopViewForROS))
		SoraDAddMessage(self, "MESSAGE_SERVER_HERO_AWAKE_SKILL_CLICK", handler(self, self.skillClick))
	end
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_STAGE_GIFT", handler(self, self.refresh))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refresh))
end
function newHeroUskillStudyView:initData(heroID)
	self.heroID = heroID
	self.skillID = nil
	self.isFromMsg = false
	self:refresh()
end
function newHeroUskillStudyView:initSp()
	local rarity = heroltCtrl:getRarity(self.heroID)
	local isShowSpNode = rarity >= gHeroQuality.BLUE
	self.fields.sp:setVisible(isShowSpNode)
	if isShowSpNode then
		self.fields.sp:initData(self.heroID)
	end
end
function newHeroUskillStudyView:initUnder()
	if self:checkIsAllUp() then
		self.isAutoSave = true
	end
	self.fields.under:initData(self.heroID, self.skillID, self:checkIsAllMax(), self.isFromMsg, self.isAutoSave, self.isAllUp, self.isAwaked)
end
function newHeroUskillStudyView:checkIsAllMax()
	local isMax = true
	for k, v in ipairs(self.skillList) do
		if v.skillID and v.buffValue < heroltCtrl:getMaxBuffValue(v.skillID) then
			isMax = false
			break
		end
	end
	return isMax
end
function newHeroUskillStudyView:checkIsAllUp()
	local isAllUp = self.isAwaked
	for k, v in ipairs(self.skillList) do
		if self.powerSkillBack[tostring(v.skillID)] and self.powerSkillBack[tostring(v.skillID)].buffValue < v.buffValue then
			isAllUp = false
			break
		end
	end
	return isAllUp
end
function newHeroUskillStudyView:runActIn()
	self:getTransition("in"):play(1, 0, 0, -1)
	self.fields.Mod_Bottom:getTransition("in"):play(1, 0, 0, -1)
end
function newHeroUskillStudyView:runActOut()
	self.fields.Mod_Bottom:getTransition("out"):play(1, 0, 0, -1)
	self:getTransition("out"):play(1, 0, 0, -1, function()
		self:setVisible(false)
	end)
end
function newHeroUskillStudyView:remakePopViewForROS(target, data)
	if not self.heroID then
		return
	end
	uiManager:show("HeroROSUskillStudyPop", data)
end
function newHeroUskillStudyView:skillClick(target, data)
	if not self.heroID then
		return
	end
	self.skillID = data.skillID
	self.isSkillClick = true
	self:refresh()
end
function newHeroUskillStudyView:judgeActivity(target, data)
	if not self.heroID then
		return
	end
	local id = data.activityID or data.eventID
	if id == gActivityTimeActivityID.HERO_AWAKE_ACTIVTY or id == gActivityTimeActivityID.HERO_AWAKE_CRIT_ACTIVTY then
		self:updateActivityBtns()
	end
end
function newHeroUskillStudyView:updateActivityBtns()
	local width = self:getWidth()
	heroltCtrl = self
	self[1] = cc.p(width - 96, 350)
	self[2] = cc.p(width - 96, 235)
	self[3] = cc.p(width - 210, 350)
	self[4] = cc.p(width - 210, 350)
	self[5] = cc.p(width - 210, 350)
	self[6] = cc.p(width - 210, 350)
	self[7] = cc.p(width - 210, 350)
	self[8] = cc.p(width - 210, 350)
	self[9] = cc.p(width - 210, 350)
	self[10] = cc.p(width - 210, 350)
	self[11] = cc.p(width - 210, 350)
	local self[12], posConfig = cc.p(width - 210, 350)
	local posIndex = 1
	for i, v in ipairs(self.activities) do
		local state = activityShowCtrl:getStateByID(v.activityID)
		local rarity = heroltCtrl:getRarity(self.heroID)
		local isShow = gActivityState.OPEN == state and rarity >= gHeroRarity.BLUE
		self.fields[v.btnName]:setVisible(isShow)
		if isShow then
			self.fields[v.btnName]:initData(v)
			self.fields[v.btnName]:setPosition(posConfig[posIndex])
			posIndex = posIndex + 1
		end
	end
end
function newHeroUskillStudyView:refreshSillEXP()
	if not self.heroID then
		return
	end
	self:initData(self.heroID)
end
function newHeroUskillStudyView:refresh(target, data)
	if not self.heroID then
		return
	end
	if data then
		self.isFromMsg = true
	end
	self.fields.Text_power:setString(string.formatnumberthousands(heroCtrl:getHeroPower(self.heroID)))
	local fileName, rarity, color = heroltCtrl:getCardRareImg(self.heroID)
	self.fields.Sprite_quality:setSpriteFrame(fileName)
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	self.rarity = heroltCtrl:getHeroRarity(self.heroID)
	self.fields.com_progress:setVisible(self.rarity == gHeroRarity.ORANGE)
	self.isAutoSave = data and data.isAuto or false
	self:initSp()
	if self.isAutoSave then
		self.isAllUp = false
		return
	end
	if not self.heroInfo.powerSkillBack then
		_ENV = self.heroInfo.powerSkillBack
	end
	self.powerSkillBack = self.heroInfo.powerSkillBack
	self.skillList, _ENV, self.isAwaked = next(self.powerSkillBack) ~= nil, next(self.powerSkillBack) ~= nil, next(self.powerSkillBack) ~= nil
	for k, v in pairs(self.heroInfo.powerSkill) do
		table.insert(self.skillList, v)
	end
	table.sort(self.skillList, function(a, b)
		return a.skillID < b.skillID
	end)
	self.skillID = self:selectSkillID()
	self.isAllUp = self:checkIsAllUp()
	self:initView()
	self:initUnder()
	self.fields.List:setNumItems(#self.skillList)
	if self.rarity == gHeroRarity.ORANGE then
		self.fields.com_progress:initData(self.heroID)
	end
end
function newHeroUskillStudyView:selectSkillID()
	local skillID
	if not IsArClient then
		for k, v in pairs(self.skillList) do
			v.isSelect = false
		end
		for k, v in pairs(self.skillList) do
			if not self.isSkillClick then
				if v.isActive and v.buffValue < heroltCtrl:getMaxBuffValue(v.skillID) then
					skillID = v.skillID
					v.isSelect = true
					break
				end
			elseif self.skillID == v.skillID then
				skillID = v.skillID
				v.isSelect = true
			end
		end
	end
	return skillID
end
function newHeroUskillStudyView:initView()
	self:updateActivityBtns()
	if self.isAllUp then
		heroCtrl:saveRemakeSkillReq(self.heroID, true)
	end
end
function newHeroUskillStudyView:recevieItemChangeMsg(target, data)
	if not self.heroID then
		return
	end
	if data and data.itemType and gItemType.HERO_CHIP == data.itemType then
		self.fields.under:updateChips()
	end
end
return newHeroUskillStudyView
