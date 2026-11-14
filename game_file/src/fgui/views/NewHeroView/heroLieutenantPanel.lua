local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local heroLieutenantPanel = class("heroLieutenantPanel", baseFguiPanel)
function heroLieutenantPanel:ctor(...)
	self.super.ctor(self, ...)
	print("heroLieutenantPanel:ctor", self.viewName)
end
function heroLieutenantPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NewHeroView"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function heroLieutenantPanel:onInit()
	self.fields.n27:fixPos()
	self.fields.n29:fixPos()
	self.quality = 1
	self.rarity = heroltCtrl:getHeroRarity(self.proxy.param.heroID)
	if not heroltCtrl:getDressCombos(self.proxy.param.dressID) then
		heroltCtrl = heroltCtrl:getDressCombos(self.proxy.param.dressID)
	end
	self.skillGroup = heroltCtrl:getDressCombos(self.proxy.param.dressID)
	self.controllers.c2:setSelectedIndex(1 < #self.skillGroup and 1 or 0)
	self.controllers.c3:setSelectedIndex((#self.skillGroup > 0 or self.rarity >= gHeroRarity.ORANGE) and 0 or 1)
	self.fields.Panel_bg:setTitle(i18n("lieutenant_text_01"))
	heroltCtrl = i18n("lieutenant_text_01")
	heroltCtrl, heroltCtrl, i18n("lieutenant_text_01").name = heroltCtrl.getHeroName(self.proxy.param.heroID)
	heroltCtrl, i18n(heroltCtrl.getHeroName(self.proxy.param.heroID)).name, heroltCtrl.getHeroName(self.proxy.param.heroID).color = heroltCtrl.getHeroName(self.proxy.param.heroID)
	i18n(heroltCtrl.getHeroName(self.proxy.param.heroID)).__default, heroltCtrl.getHeroName(self.proxy.param.heroID).color = heroltCtrl.getHeroName(self.proxy.param.heroID)
	self.fields.text_Tips:setString(i18n_html("lieutenant_text_02", i18n("lieutenant_text_01")))
	self.fields.heroHead:initData(self.proxy.param.heroID)
	local heroInfo = heroCtrl:getHeroInfoByID(self.proxy.param.heroID)
	local heroQuality = heroInfo and heroInfo.quality or 1
	self.fields.heroHead:setHeadBg(heroQuality)
	self.fields.heroHead:setSpHead(self.proxy.param.dressID)
	self.fields.scroll:setItemRenderer(handler(self, self.onItemAttrRenderer))
	self.fields.scrollEx:setItemRenderer(handler(self, self.onItemAttrExRenderer))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.touchPanel:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onTouchStart))
	self.fields.touchPanel:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onTouchEnd))
	local heroInfo = heroCtrl:getHeroInfoByID(self.proxy.param.heroID)
	local addCfg = heroltCtrl:getInheriAttrAdd(heroInfo and heroInfo.level)
	heroltCtrl = handler(self, self.onTouchEnd)
	handler(self, self.onTouchEnd).num1 = fguiHelper.getColorString("#FFC864", string.format("%d%%", addCfg.stuntAttrAdd / 100))
	handler(self, self.onTouchEnd).num2 = fguiHelper.getColorString("#FFC864", string.format("%d%%", addCfg.awakeAttrAdd / 100))
	self.fields.textSpecial:setString(i18n("hero_appoint_42", handler(self, self.onTouchEnd)))
	self.fields.textSpecial:setVisible(false)
	self.fields.attrTitle:setTitle3(i18n("lieutenant_text_06"), i18n("lieutenant_text_07"), i18n("lieutenant_text_18"))
	self.fields.attrTitleEx:setTitle3(i18n("lieutenant_text_29"), i18n("lieutenant_text_28"))
	self.fields.textAttrTitle:setString(i18n("lieutenant_text_03"))
	_UPVALUE4_ = self.fields.textAttrTitle
	self.fields.textAttrTitle[1] = "n42"
	self.fields.textAttrTitle[2] = "Sprite_skillBg"
	self.fields.textAttrTitle[3] = "skillIcon"
	self.fields.textAttrTitle[4] = "textSkillLv"
	for i, v in ipairs(self.fields.textAttrTitle) do
		self.fields[v]:fixPos()
	end
end
function heroLieutenantPanel:onShow()
	self.inheritAttrList = heroltCtrl:getHeroInheritAttr()
	self.inheritAttrListAwake = heroltCtrl:getHeroInheritAttrAwake()
	self:initSkillInfo()
	if self.rarity >= gHeroRarity.ORANGE then
		if next(self.skillGroup) then
			heroltCtrl = nil
			heroltCtrl, heroltCtrl, (nil).defaultClick = nil, self.proxy.param.viewTab or 1, self.proxy.param.viewTab or 1
			;(nil).title = i18n("lieutenant_text_03")
			heroltCtrl, (self.proxy.param.viewTab or 1)[1], (nil).tag = nil, nil, 1
			;(nil).title = i18n("lieutenant_text_26")
			heroltCtrl, (self.proxy.param.viewTab or 1)[2], (nil).tag = nil, nil, 2
			;(nil).title = i18n("lieutenant_text_04")
			;(nil).tabsetArray, (self.proxy.param.viewTab or 1)[3], (nil).tag = self.proxy.param.viewTab or 1, nil, 3
			;(nil).callback = handler(self, self.onClickRankTag)
			self.fields.com_Tab:initView(nil)
		else
			heroltCtrl = nil
			heroltCtrl, heroltCtrl, (nil).defaultClick = self, self.proxy.param.viewTab or 1, self.proxy.param.viewTab or 1
			self.title = i18n("lieutenant_text_03")
			heroltCtrl, (self.proxy.param.viewTab or 1)[1], self.tag = self, self, 1
			self.title = i18n("lieutenant_text_26")
			;(nil).tabsetArray, (self.proxy.param.viewTab or 1)[2], self.tag = self.proxy.param.viewTab or 1, self, 2
			;(nil).callback = handler(self, self.onClickRankTag)
			self.fields.com_Tab:initView(nil)
		end
	elseif next(self.skillGroup) then
		heroltCtrl = nil
		heroltCtrl, heroltCtrl, (nil).defaultClick = self, self.proxy.param.viewTab or 1, self.proxy.param.viewTab or 1
		self.title = i18n("lieutenant_text_03")
		heroltCtrl, (self.proxy.param.viewTab or 1)[1], self.tag = self, self, 1
		self.title = i18n("lieutenant_text_04")
		;(nil).tabsetArray, (self.proxy.param.viewTab or 1)[2], self.tag = self.proxy.param.viewTab or 1, self, 3
		;(nil).callback = handler(self, self.onClickRankTag)
		self.fields.com_Tab:initView(nil)
	else
		self:onClickRankTag(1)
	end
	self.fields.scroll:setNumItems(#self.inheritAttrList)
	self.fields.scrollEx:setNumItems(#self.inheritAttrListAwake)
end
function heroLieutenantPanel:initSkillInfo()
	print("self.heroQuality", self.heroQuality)
	if next(self.skillGroup) then
		_ENV = nil
		;(nil).name1 = i18n(heroltCtrl.getHeroName(self.proxy.param.heroID))
		;(nil).name2 = i18n(heroltCtrl.getHeroName(self.proxy.param.lieutenantHeroID))
		self.fields.textSkillExplain:setString(i18n("lieutenant_text_08", nil))
		self.fields.com_Head2:initData(self.proxy.param.lieutenantHeroID)
		local heroInfo = heroCtrl:getHeroInfoByID(self.proxy.param.lieutenantHeroID)
		self.isOwnLeutenant = heroInfo and true or false
		self.heroQuality = heroInfo and heroInfo.quality or 1
		self.heroNowQuality = self.heroQuality
		self.fields.com_Head2:setHeadBg(self.heroQuality)
		if not self.isOwnLeutenant then
			self.fields.com_Head2:setHeadBg(1)
		else
			self.fields.com_Head2:setHeadBg(self.heroQuality)
		end
		local _ENV, tabsetArray = self.fields.com_Head2.setHeadBg, self.fields.com_Head2.setHeadBg
		for i, skillGroup in ipairs(self.skillGroup) do
			local skillId = tonumber(skillGroup .. string.format("%02d", self.heroQuality))
			local skillInfo = heroltCtrl:getCombosSkillInfo(skillId)
			_ENV = self.heroQuality
			self.heroQuality.title = i18n(skillInfo.skillName)
			self.heroQuality.tag = i
			table.insert(tabsetArray, self.heroQuality)
		end
		self.skillIndex = self.proxy.param.skillIndex or 1
		_ENV = ipairs(self.skillGroup)
		ipairs(self.skillGroup).defaultClick = self.skillIndex
		ipairs(self.skillGroup).tabsetArray = tabsetArray
		ipairs(self.skillGroup).callback = handler(self, self.onClickSkillTag)
		self.fields.com_TabSkill:initView(ipairs(self.skillGroup))
		self.fields.list:setNumItems(5)
	end
end
function heroLieutenantPanel:onClickRankTag(tag)
	self.controllers.c1:setSelectedIndex(tag - 1)
	self.fields.textSpecial:setVisible(self.rarity >= gHeroRarity.ORANGE and tag == 1)
	self.fields.textAttriExplain:setString(tag == 1 and i18n("lieutenant_text_05") or i18n("lieutenant_text_27"))
	self.fields.n27:setVisible(tag == 1)
end
function heroLieutenantPanel:onItemAttrRenderer(index, object)
	object:initData(self.inheritAttrList[index + 1], index, self.rarity >= gHeroRarity.ORANGE)
end
function heroLieutenantPanel:onItemAttrExRenderer(index, object)
	object:initDataEx(self.inheritAttrListAwake[index + 1], index)
end
function heroLieutenantPanel:onItemRenderer(index, object)
	fguiHelper.get_controllers(object).c1:setSelectedIndex(index + 1 == self.heroQuality and 0 or 1)
end
function heroLieutenantPanel:onClickSkillTag(tag)
	self.skillIndex = tag
	self.skillId = tonumber(self.skillGroup[self.skillIndex] .. string.format("%02d", self.heroQuality))
	local skillInfo = heroltCtrl:getCombosSkillInfo(self.skillId)
	self.fields.textSkillDes:setString(heroCtrl:getComboSkillDes(self.skillId))
	self.fields.skillIcon:setIcon(skillInfo.skillIcon)
	self.fields.textSkillName:setString(i18n(skillInfo.skillName))
	_ENV = i18n(skillInfo.skillName)
	i18n(skillInfo.skillName).lv = self.heroQuality
	local strLv = i18n("common_text_277", i18n(skillInfo.skillName))
	if self.isOwnLeutenant and self.heroNowQuality == self.heroQuality then
		strLv = i18n("lieutenant_text_09") .. strLv
	end
	self.fields.textSkillLv:setString(strLv)
	self.fields.Sprite_skillBg:setURL(heroltCtrl.getSkillBg(self.heroQuality))
end
function heroLieutenantPanel:onTouchStart(eventContext)
	print("=======heroLieutenantPanel:onTouchStart")
	self.touchBeganPoint = eventContext:getInput():getPosition()
	self.isMove = false
end
function heroLieutenantPanel:onTouchEnd(eventContext)
	print("=======heroLieutenantPanel:onTouchEnd")
	if self.touchBeganPoint == nil then
		return
	end
	self.touchEndPoint = eventContext:getInput():getPosition()
	local distance = cc.pGetDistance(self.touchBeganPoint, self.touchEndPoint)
	if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
		self.isMove = true
	else
		self.isMove = false
	end
	if self.isMove then
		if self.touchBeganPoint.x > self.touchEndPoint.x then
			if SoraDFIsRA() then
				self.heroQuality = math.max(self.heroQuality - 1, 1)
			else
				self.heroQuality = math.min(self.heroQuality + 1, 5)
			end
		elseif SoraDFIsRA() then
			self.heroQuality = math.min(self.heroQuality + 1, 5)
		else
			self.heroQuality = math.max(self.heroQuality - 1, 1)
		end
		self:onClickSkillTag(self.skillIndex)
		self.fields.list:setNumItems(5)
	end
	self.touchBeganPoint = nil
	self.touchEndPoint = nil
	self.isMove = false
end
function heroLieutenantPanel:onHide()
	print("=======heroLieutenantPanel:onHide")
end
function heroLieutenantPanel:onDispose()
	print("=======heroLieutenantPanel:onDispose")
end
return heroLieutenantPanel
