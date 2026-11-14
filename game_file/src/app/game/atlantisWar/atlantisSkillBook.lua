local ASD = require_data("atlantiswar_skill_display").data
local qualityConfig = gAtlantisQualityConfig
local atlantisSkillBook = class("atlantisSkillBook", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisSkillBook")
	end
	return target
end)
function atlantisSkillBook:ctor(target, activityID)
	print("==atlantisSkillBook:ctor==", target, activityID)
	self.activityID = activityID
	if self.activityID == gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY then
		local roaringFlameWarRead = include("roaringFlameWarRead")
		self.config = roaringFlameWarRead.getSkillDisplay()
	else
		self.config = ASD
	end
	self.isSelect = false
	_ENV, self.tableSpare, _ENV, self.skillList, _ENV, self.titleList, _ENV, self.curSelectIndex = ASD, ASD, ASD, ASD, ASD, ASD, ASD, 1
	ASD[1] = "atlantiswar_skill_text_016"
	_ENV, _ENV, self.sortConfig, ASD[2] = roaringFlameWarRead.getSkillDisplay(), ASD, ASD, "atlantiswar_skill_text_017"
	roaringFlameWarRead.getSkillDisplay().quality = 3
	_ENV, ASD[1], roaringFlameWarRead.getSkillDisplay().bg = roaringFlameWarRead.getSkillDisplay(), roaringFlameWarRead.getSkillDisplay(), "frame_zqlz_rankbg_01.png"
	roaringFlameWarRead.getSkillDisplay().quality = 2
	_ENV, ASD[2], roaringFlameWarRead.getSkillDisplay().bg = roaringFlameWarRead.getSkillDisplay(), roaringFlameWarRead.getSkillDisplay(), "frame_zqlz_rankbg_03.png"
	roaringFlameWarRead.getSkillDisplay().quality = 1
	self.titleConfig, ASD[3], roaringFlameWarRead.getSkillDisplay().bg = ASD, roaringFlameWarRead.getSkillDisplay(), "frame_zqlz_rankbg_04.png"
	self:initWidget()
	self:initData()
end
function atlantisSkillBook:onMessageListener()
end
function atlantisSkillBook:initWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("atlantiswar_skill_text_003"))
	_UPVALUE2_ = i18n("atlantiswar_skill_text_003")
	i18n("atlantiswar_skill_text_003")[1] = "Center_Node"
	i18n("atlantiswar_skill_text_003")[2] = "Node_select"
	self.Node_select = SoraDGetChildByFullPath(self._ccsView, i18n("atlantiswar_skill_text_003"))
	SoraDGetAllChildFromWidget(self.Node_select, self)
	for i, v in ipairs(self.sortConfig) do
		self["Text_select" .. i]:setString(i18n(v))
	end
	_UPVALUE3_ = ipairs(self.sortConfig)
	ipairs(self.sortConfig)[1] = self.Button_select
	ipairs(self.sortConfig)[2] = self.Button_select1
	ipairs(self.sortConfig)[3] = self.Button_select2
	for i, v in ipairs(ipairs(self.sortConfig)) do
		v:addTouchEventListener(handler(self, self.btnSelectClick))
	end
	_UPVALUE2_ = ipairs(ipairs(self.sortConfig))
	ipairs(ipairs(self.sortConfig))[1] = "Center_Node"
	ipairs(ipairs(self.sortConfig))[2] = "ScrollView_skill"
	self.scroll = SoraDGetChildByFullPath(self._ccsView, ipairs(ipairs(self.sortConfig)))
	_UPVALUE1_ = ipairs(ipairs(self.sortConfig))
	ipairs(ipairs(self.sortConfig))[1] = "Node_titleSingle"
	self.Node_titleSingle = SoraDGetChildByFullPath(self._ccsView, ipairs(ipairs(self.sortConfig)))
	_UPVALUE1_ = ipairs(ipairs(self.sortConfig))
	ipairs(ipairs(self.sortConfig))[1] = "Node_skillSingle"
	self.Node_skillSingle = SoraDGetChildByFullPath(self._ccsView, ipairs(ipairs(self.sortConfig)))
	self.Node_titleSingle:setVisible(false)
	self.Node_skillSingle:setVisible(false)
	for i = 1, 3 do
		local single = self:createTitleSingle(i)
		single:addTo(self.scroll)
		self.titleList[i] = single
	end
end
function atlantisSkillBook:createTitleSingle(index)
	local single = self.Node_titleSingle:clone()
	single:setVisible(true)
	SoraDGetAllChildFromWidget(single, single)
	self:refreshTitleColor(single, index)
	return single
end
function atlantisSkillBook:refreshTitleColor(single, index)
	local config = self.titleConfig[index]
	SoraChangeSpriteImage(single.Image_frameBg1, config.bg)
	SoraChangeSpriteImage(single.Image_frameBg2, config.bg)
	single.Text_title:setColor(qualityConfig[config.quality].color)
end
function atlantisSkillBook:initData(...)
	local _ENV, qualityList
	local _ENV, typeList
	for __, config in pairs(self.config) do
		if not qualityList[config.quality] then
			_ENV = qualityList[config.quality]
		end
		qualityList[config.quality] = qualityList[config.quality]
		table.insert(qualityList[config.quality], config.skillID)
		if not typeList[config.sort] then
			_ENV = typeList[config.sort]
		end
		typeList[config.sort] = typeList[config.sort]
		table.insert(typeList[config.sort], config.skillID)
	end
	for i = 1, 3 do
		if not qualityList[i] then
			_ENV = qualityList[i]
		end
		qualityList[i] = qualityList[i]
		table.sort(qualityList[i])
		if not typeList[i] then
			_ENV = typeList[i]
		end
		typeList[i] = typeList[i]
		table.sort(typeList[i], function(a, b)
			local qualityA = self.config[a].quality
			local qualityB = self.config[b].quality
			if qualityA ~= qualityB then
				return qualityA > qualityB
			end
			return a < b
		end)
	end
	_ENV = (for index)
	;(1)[1] = qualityList
	self.sortData, (1)[2] = 1, typeList
	self:refreshSelectIndex()
	self:refreshNodeSelect()
end
function atlantisSkillBook:btnSelectClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isSelect = not self.isSelect
		self:refreshNodeSelect()
		if button == self.Button_select1 and self.curSelectIndex ~= 1 then
			self.curSelectIndex = 1
			self:refreshSelectIndex()
		elseif button == self.Button_select2 and self.curSelectIndex ~= 2 then
			self.curSelectIndex = 2
			self:refreshSelectIndex()
		end
	end
end
function atlantisSkillBook:refreshNodeSelect(...)
	self.Sprite_arrow:setFlippedY(not self.isSelect)
	self.Node_selectList:setVisible(self.isSelect)
end
function atlantisSkillBook:refreshSelectIndex(...)
	self.Text_select:setString(i18n(self.sortConfig[self.curSelectIndex]))
	self.Image_select:setPositionY(self["Node_select" .. self.curSelectIndex]:getPositionY())
	self:refreshScroll()
end
function atlantisSkillBook:refreshScroll(...)
	self.scroll:jumpToTop()
	for i, v in ipairs(self.skillList) do
		v:setVisible(false)
		table.insert(self.tableSpare, v)
	end
	self.skillList, _ENV = ipairs(self.skillList)
	local sSize = self.scroll:getContentSize()
	local titleH = 40
	local space = 10
	local skillW, skillH = 120, 150
	local totalRow = 0
	local titleCount = 0
	for i, v in ipairs(self.titleList) do
		local config = self.titleConfig[i]
		local quality = config.quality
		if not self.sortData[self.curSelectIndex][quality] then
			local _ENV, sortData = self.sortData[self.curSelectIndex][quality], self.sortData[self.curSelectIndex][quality]
		end
		if #sortData <= 0 then
			v:setVisible(false)
		else
			v:setVisible(true)
			totalRow = totalRow + math.ceil(#sortData / 4)
			titleCount = titleCount + 1
		end
	end
	local totalH = (titleH + space * 2) * titleCount + totalRow * skillH
	local scrollH = math.max(totalH, sSize.height)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, scrollH))
	local curScrollH = scrollH
	for i, v in ipairs(self.titleList) do
		local config = self.titleConfig[i]
		local qConfig = qualityConfig[config.quality]
		if self.curSelectIndex == 1 then
			v.Text_title:setString(i18n(qConfig.qName))
			self:refreshTitleColor(v, i)
		elseif self.curSelectIndex == 2 then
			v.Text_title:setString(i18n(qConfig.tName))
			self:refreshTitleColor(v, 3)
			v.Text_title:setColor(cc.c3b(215, 195, 155))
		end
		v:setPosition(sSize.width / 2, curScrollH - titleH / 2)
		local posy = v:getPositionY()
		local sortData = self.sortData[self.curSelectIndex][config.quality]
		local rowMax = math.ceil(#sortData / 4)
		curScrollH = curScrollH - titleH - space * 2 - rowMax * skillH
		for j, skillID in ipairs(sortData) do
			local skill = self:createSkillSingle(skillID)
			local row = math.ceil(j / 4)
			local col = (j - 1) % 4 + 1
			skill:setPosition(sSize.width / 2 - SoraDFSign(col - 2.5) * skillW, posy - skillH * row + 60)
			table.insert(self.skillList, skill)
		end
	end
end
function atlantisSkillBook:createSkillSingle(skillID)
	local single
	if #self.tableSpare > 0 then
		single = table.remove(self.tableSpare)
	else
		single = self.Node_skillSingle:clone()
		single:addTo(self.scroll)
		SoraDGetAllChildFromWidget(single, single)
		SoraDCreatePanelByCloneNode(single.Button_skill, "commonBtnInstance")
		single.Button_skill:setHandle(handler(self, self.btnSkillClick))
		single.Button_skill:setScroll(self.scroll)
		single.Button_skill:setSwallowTouches(false)
	end
	single:setVisible(true)
	local config = self.config[skillID]
	local qConfig = qualityConfig[config.quality]
	single.Text_skill:setString(i18n(config.name))
	single.Text_skill:setColor(qConfig.color)
	SoraChangeSpriteImage(single.Image_skill, config.img)
	single.Button_skill:setTag(skillID)
	SoraChangeSpriteImage(single.Image_quality, qConfig.qImage)
	return single
end
function atlantisSkillBook:btnSkillClick(button, eventType)
	local panel = SoraDCreatePanel("atlantisSkillDetail")
	panel:initData(button:getTag())
	panel:show()
end
return atlantisSkillBook
