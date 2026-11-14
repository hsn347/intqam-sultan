local buildMoreInfo = include("buildMoreInfoRead")
local buildDescribe = include("buildDescribeRead")
local buildLogic = include("buildLogic")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BuildMoreInfoPanel = class("BuildMoreInfoPanel", baseFguiPanel)
function BuildMoreInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BuildMoreInfoPanel:ctor", self.viewName)
end
function BuildMoreInfoPanel:onInit()
	print("=======BuildMoreInfoPanel:onInit")
end
function BuildMoreInfoPanel:onShow()
	print("=======BuildMoreInfoPanel:onShow")
	local manorInfo = self.param.manorInfo
	if manorInfo then
		self:initManorData(manorInfo)
	else
		self:initData(self.param.buildInfo)
	end
end
function BuildMoreInfoPanel:initData(buildInfo)
	self.tableBuildInfo = buildInfo
	if buildInfo.isStar then
		self.tableBuildMore = buildMoreInfo.getStarMoreInfoData(self.tableBuildInfo.bid)
	else
		self.tableBuildMore = buildMoreInfo.getMoreInfoData(self.tableBuildInfo.bid)
	end
	if not commonCheck.ARTIFACT and self.tableBuildInfo.bid == BUILDID.WATCH_TOWER then
		self.tableBuildMore[18][2][1] = ""
		self.tableBuildMore[22][2][1] = ""
	end
	self:initOldInfo()
	if self:checkStarLampUnlock() then
		self:initNewInfo()
		self:delayInitScrollNew()
		self.controllers.c_tab:setSelectedIndex(0)
	else
		self.controllers.c_tab:setSelectedIndex(1)
	end
	self:addScrollView(self.fields.scroll, self.tableBuildMore, not buildInfo.isStar)
end
function BuildMoreInfoPanel:btn_onClick_btns(tag, name)
	self.controllers.c1:setSelectedIndex(tag - 1)
	if tag == 2 then
		self:checkScrollNew()
	end
end
function BuildMoreInfoPanel:delayInitScrollNew(...)
	_UPVALUE2_ = nil
	;(nil)[1] = ffa.callFunc(function()
	end)
	;(nil)[2] = ffa.delay(0.01)
	;(nil)[3] = ffa.callFunc(function()
		self:checkScrollNew()
	end)
	;(nil)[4] = ffa.callFunc(function()
		self:checkScrollNew()
	end)
	self.view:runAction(ffa.seq(nil))
end
function BuildMoreInfoPanel:checkScrollNew(...)
	if not self.hasInitScrollNew then
		self.hasInitScrollNew = true
		self.tableBuildStarMore = buildMoreInfo.getStarMoreInfoData(self.tableBuildInfo.bid)
		self:addScrollView(self.fields.scrollStar, self.tableBuildStarMore, false)
	end
end
function BuildMoreInfoPanel:initOldInfo(...)
	local warLv = buildLogic.transformBuildLvToWarLv(self.tableBuildInfo.blv)
	local buildName = buildDescribe.getName(self.tableBuildInfo.bid)
	if self.tableBuildInfo.bid == BUILDID.MIRACLE or self.tableBuildInfo.bid == BUILDID.STAR_BRAVE_STATUE then
		self.fields.Panel_bg:setString(buildName)
	else
		buildLogic = nil
		;(nil).name = buildName
		;(nil).lv = math.min(self.tableBuildInfo.blv, 30)
		self.fields.Panel_bg:setString(i18n("common_text_334", nil))
	end
end
function BuildMoreInfoPanel:initNewInfo(...)
	local warLv = buildLogic.transformBuildLvToWarLv(self.tableBuildInfo.blv)
	local buildName = buildDescribe.getName(self.tableBuildInfo.bid)
	self.fields.Panel_bg:setString(buildName)
	local starLv = self.tableBuildInfo.starLv
	buildLogic, buildLogic = buildName, self.fields.Panel_bg
	buildLogic = nil
	;(nil).lv = warLv
	buildLogic, self.fields.Panel_bg[1], buildName.title = buildName, buildName, i18n("common_text_1948", nil)
	buildLogic = nil
	;(nil).lv = starLv ~= 0 and starLv or ""
	self.fields.Panel_bg[2], buildName.title = buildName, i18n("Glory_text_26", nil)
	local tabConfig = self.fields.Panel_bg
	buildLogic = "Glory_text_26"
	;("Glory_text_26").defaultClick = 1
	;("Glory_text_26").tabsetArray = tabConfig
	;("Glory_text_26").callback = handler(self, self.btn_onClick_btns)
	self.fields.com_TabW:initView("Glory_text_26")
end
function BuildMoreInfoPanel:addScrollView(scrollInfo, tableBuildMore, isNormal)
	local _fields = fguiHelper.get_fields(scrollInfo)
	local nodeNormal = _fields.Com_item
	local _ENV, tableNormal
	local _ENV, tableWar
	for i, v in ipairs(tableBuildMore) do
		if not isNormal or i <= CASTLE_MINLV_WAR and self.tableBuildInfo.bid ~= BUILDID.MIRACLE then
			table.insert(tableNormal, v)
		else
			table.insert(tableWar, v)
		end
	end
	local curLv
	local warLv = buildLogic.transformBuildLvToWarLv(self.tableBuildInfo.blv)
	local buildName = buildDescribe.getName(self.tableBuildInfo.bid)
	if isNormal then
		curLv = 0 < warLv and -1 or math.min(self.tableBuildInfo.blv, CASTLE_MAXLV_NOWAR)
	else
		curLv = self.tableBuildInfo.starLv or 0
	end
	local itemFields = fguiHelper.get_fields(nodeNormal)
	local Text_name = itemFields.Com_title
	local Text_des = itemFields.Text_des
	if isNormal then
		_ENV = nil
		;(nil).name = buildName
		Text_name:setString(i18n("common_text_377", nil))
		Text_des:setString(buildDescribe.getDes(self.tableBuildInfo.bid))
	else
		if self.tableBuildInfo.bid == BUILDID.STAR_BRAVE_STATUE then
			_ENV = buildDescribe.getDes(self.tableBuildInfo.bid)
			buildDescribe.getDes(self.tableBuildInfo.bid).name = buildName
			Text_name:setString(i18n("common_text_377", buildDescribe.getDes(self.tableBuildInfo.bid)))
		else
			_ENV = i18n("common_text_377", buildDescribe.getDes(self.tableBuildInfo.bid))
			i18n("common_text_377", buildDescribe.getDes(self.tableBuildInfo.bid)).build = buildName
			itemFields.Com_title:setString(i18n("Glory_text_28", i18n("common_text_377", buildDescribe.getDes(self.tableBuildInfo.bid))))
		end
		Text_des:setString(buildDescribe.getStarDes(self.tableBuildInfo.bid))
	end
	self:createLabel(nodeNormal, tableNormal, curLv)
	local warPosY = nodeNormal:getContentSize().height
	if #tableNormal == 0 then
		nodeNormal:setVisible(false)
		warPosY = 0
	end
	if self.tableBuildInfo.blv >= CASTLE_MAXLV_NOWAR and 0 < #tableWar then
		local nodeWar = nodeNormal:clone()
		nodeWar:setVisible(true)
		nodeWar:addTo(scrollInfo)
		nodeWar:setPositionY(warPosY)
		local itemFields = fguiHelper.get_fields(nodeWar)
		local Text_name = itemFields.Com_title
		local Text_des = itemFields.Text_des
		_ENV = buildDescribe.getStarDes(self.tableBuildInfo.bid)
		buildDescribe.getStarDes(self.tableBuildInfo.bid).build = buildName
		Text_name:setString(i18n("common_text_1958", buildDescribe.getStarDes(self.tableBuildInfo.bid)))
		Text_des:setString(buildDescribe.getWarDes(self.tableBuildInfo.bid))
		self:createLabel(nodeWar, tableWar, 0 < warLv and warLv or -1)
	end
end
function BuildMoreInfoPanel:createLabel(obj, data, curLv)
	if #data == 0 or obj == nil then
		return 0
	end
	local _fields = fguiHelper.get_fields(obj)
	local Info_title = _fields.Info_title
	local lineNum = table.nums(data[1])
	local rowNum = table.maxn(data)
	local needPower = self.tableBuildInfo.bid ~= BUILDID.WISHING_WELL and not (lineNum <= 2)
	local lvW = 0
	local powerW = 0
	local getWLabel = self.getWLabel or fgui.UIPackage:createObject("BuildViewCommon", "MoreInfo_text")
	if self.getWLabel == nil then
		self.getWLabel = getWLabel
		self.getWLabel:setOpacity(0)
		self.getWLabel:addTo(self)
	end
	for i, v in ipairs(data) do
		getWLabel:setString(v[1][1])
		lvW = math.max(lvW, getWLabel:getContentSize().width)
		if needPower and v[lineNum][2] ~= "image" then
			getWLabel:setString(v[lineNum][1])
			powerW = math.max(powerW, getWLabel:getContentSize().width)
		end
	end
	powerW = needPower and powerW + 15 or powerW
	lvW = 0 < lvW and lvW + 15 or lvW
	local singleW = (obj:getViewWidth() - lvW - powerW) / (needPower and lineNum - 2 or lineNum - 1)
	_ENV = needPower and lineNum - 2 or lineNum - 1
	;(needPower and lineNum - 2 or lineNum - 1).obj = Info_title
	;(needPower and lineNum - 2 or lineNum - 1).data = data[1]
	;(needPower and lineNum - 2 or lineNum - 1).lvW = lvW
	;(needPower and lineNum - 2 or lineNum - 1).powerW = powerW
	;(needPower and lineNum - 2 or lineNum - 1).singleW = singleW
	;(needPower and lineNum - 2 or lineNum - 1).needPower = needPower
	local (needPower and lineNum - 2 or lineNum - 1).lineNum, params = lineNum, needPower and lineNum - 2 or lineNum - 1
	self:initInfoSingle(params)
	if self.tableBuildInfo.bid == BUILDID.STAR_BRAVE_STATUE then
		local _ENV, imageLineList = self.tableBuildInfo.bid, self.tableBuildInfo.bid
		for i = 1, lineNum - 1 do
			local Image_line = _fields.Image_line
			if i ~= 1 then
				Image_line = Image_line:clone()
				Image_line:addTo(obj)
			end
			table.insert(imageLineList, Image_line)
			Image_line:setContentSize(cc.size(3, 1136))
			Image_line:setPosition(cc.p(lvW + (i - 1) * singleW, _fields.Image_line:getPositionY()))
			if SoraDFIsRA() then
				Image_line:fixPos(true)
			end
		end
		_fields.List:setItemRenderer(function(_index, _obj)
			local _data = data[_index + 1 + 1]
			params.obj = _obj
			params.data = _data
			params.showWhite = _index % 2 == 0
			params.showLight = 0 < curLv and _index + 1 == curLv
			local itemCount = #data - 1
			if _index < 30 then
				self:initInfoSingle(params)
				if _index == #data - 2 then
					_fields.List:resizeToFit(itemCount)
					local scrollH = Info_title:getViewHeight() + _fields.List:getViewHeight()
					for __, Image_line in ipairs(imageLineList) do
						Image_line:setContentSize(cc.size(3, scrollH))
					end
				end
			else
				local time = math.ceil(_index / 10) / 60
				local _params = clone(params)
				params = nil
				;(nil)[1] = ffa.delay(time)
				;(nil)[2] = ffa.callFunc(function()
					self:initInfoSingle(_params)
					if _index == #data - 2 then
						_fields.List:resizeToFit(itemCount)
						local scrollH = Info_title:getViewHeight() + _fields.List:getViewHeight()
						for __, Image_line in ipairs(imageLineList) do
							Image_line:setContentSize(cc.size(3, scrollH))
						end
					end
				end)
				;(nil)[3] = ffa.callFunc(function()
					self:initInfoSingle(_params)
					if _index == #data - 2 then
						_fields.List:resizeToFit(itemCount)
						local scrollH = Info_title:getViewHeight() + _fields.List:getViewHeight()
						for __, Image_line in ipairs(imageLineList) do
							Image_line:setContentSize(cc.size(3, scrollH))
						end
					end
				end)
				;(nil)[4] = ffa.callFunc(function()
					self:initInfoSingle(_params)
					if _index == #data - 2 then
						_fields.List:resizeToFit(itemCount)
						local scrollH = Info_title:getViewHeight() + _fields.List:getViewHeight()
						for __, Image_line in ipairs(imageLineList) do
							Image_line:setContentSize(cc.size(3, scrollH))
						end
					end
				end)
				;(nil)[5] = ffa.callFunc(function()
					self:initInfoSingle(_params)
					if _index == #data - 2 then
						_fields.List:resizeToFit(itemCount)
						local scrollH = Info_title:getViewHeight() + _fields.List:getViewHeight()
						for __, Image_line in ipairs(imageLineList) do
							Image_line:setContentSize(cc.size(3, scrollH))
						end
					end
				end)
				self.view:runAction(ffa.seq(nil))
			end
		end)
		_fields.List:setNumItems(#data - 1)
		return
	end
	_fields.List:setItemRenderer(function(_index, _obj)
		local _data = data[_index + 1 + 1]
		params.obj = _obj
		params.data = _data
		params.showWhite = _index % 2 == 0
		params.showLight = 0 < curLv and _index + 1 == curLv
		self:initInfoSingle(params)
	end)
	_fields.List:setNumItems(#data - 1)
	_fields.List:resizeToFit(#data - 1)
	local scrollH = Info_title:getViewHeight() + _fields.List:getViewHeight()
	for i = 1, lineNum - 1 do
		local Image_line = _fields.Image_line
		if i ~= 1 then
			Image_line = Image_line:clone()
			Image_line:addTo(obj)
		end
		Image_line:setContentSize(cc.size(3, scrollH))
		Image_line:setPosition(cc.p(lvW + (i - 1) * singleW, _fields.Image_line:getPositionY()))
		if SoraDFIsRA() then
			Image_line:fixPos(true)
		end
	end
end
function BuildMoreInfoPanel:initInfoSingle(p)
	local obj, data, showWhite, showLight, lvW, powerW, singleW, needPower, lineNum = p.obj, p.data, p.showWhite, p.showLight, p.lvW, p.powerW, p.singleW, p.needPower, p.lineNum
	local _fields = fguiHelper.get_fields(obj)
	_fields.Text_value:setVisible(false)
	if _fields.imgWhite then
		_fields.imgWhite:setVisible(showWhite or false)
		_fields.imgLight:setVisible(showLight or false)
	end
	local maxH = 0
	for i, singleInfo in ipairs(data) do
		if singleInfo[2] == "image" then
			local iconSize = cc.size(50, 55)
			local iconValue = fgui.UIPackage:createObject("BuildViewCommon", "MoreInfo_image")
			iconValue:addTo(obj)
			local posx = lvW + (i - 2) * singleW + 5
			iconValue:setPosition(posx, 4)
			iconValue:setIcon(singleInfo[1])
			iconValue:setContentSize(iconSize)
			iconValue:addLongPressListener(handlerEx(self, self.btnClickTitleIcon, singleInfo[1]))
			maxH = math.max(maxH, iconSize.height)
		else
			local tmpSingleW = singleW
			local labelValue = _fields.Text_value:clone()
			labelValue:setTitleColor(_fields.Text_value:getTitleColor())
			labelValue:setVisible(true)
			labelValue:setString(singleInfo[1])
			labelValue:addTo(obj)
			if showLight then
				labelValue:setTitleColor(cc.c3b(255, 255, 255))
			end
			local Text_title = labelValue:getChild("title")
			local posx = lvW + (i - 2) * singleW + 5
			if i == 1 then
				posx = 7.5
				Text_title:setAlign(cc.TEXT_ALIGNMENT_CENTER)
				tmpSingleW = lvW
			elseif needPower and i == lineNum then
				tmpSingleW = powerW
			end
			labelValue:setPosition(posx, 4)
			local tmpH = 0
			if singleInfo[2] == "string" or maxH == 0 then
				Text_title:setAutoSize(fgui.AutoSizeType.HEIGHT)
				Text_title:setWidth(tmpSingleW - 10)
				tmpH = labelValue:getViewHeight()
			else
				Text_title:setAutoSize(fgui.AutoSizeType.SHRINK)
				Text_title:setSize(cc.size(tmpSingleW - 10, maxH))
			end
			local j
			if i == 1 and j == 7 and self.tableBuildInfo.bid == BUILDID.WISHING_WELL and SoraDGetDefaultLanguage() == "ar" then
				Text_title:setWidth(tmpSingleW)
			end
			maxH = math.max(maxH, tmpH)
		end
	end
	maxH = maxH + 8
	obj:setViewHeight(maxH)
	if SoraDFIsRA() then
		obj:fixChildrenPos(false, true)
	end
end
function BuildMoreInfoPanel:checkStarLampUnlock(...)
	return SoraDCheckIsOpenBuildStar() and self.tableBuildInfo.blv >= CASTLE_LV90_LIMITED
end
function BuildMoreInfoPanel:btnClickTitleIcon(iconName, button, startPos, endPos)
	SoraDPlaySound()
	local info = buildMoreInfo.getInfoByIconName(iconName)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	;(nil).pos = startPos
	;(nil).customName = i18n(info.name)
	;(nil).customTip = i18n(info.des)
	SoraDSendMessage(nil)
end
function BuildMoreInfoPanel:initManorData(manorInfo)
	local manorCityUtil = include("manorCityUtil")
	local manorCityRead = include("manorCityRead")
	self.tableBuildInfo = manorInfo
	self.tableBuildMore = manorCityUtil.getBuildMoreInfo(manorInfo.bid)
	local buildName = manorCityRead.getBuildName(manorInfo.bid, manorInfo.extra)
	self.fields.Panel_bg:setString(buildName)
	self.controllers.c_tab:setSelectedIndex(1)
	self:addManorScrollView(self.fields.scroll, self.tableBuildMore)
end
function BuildMoreInfoPanel:addManorScrollView(scrollInfo, tableBuildMore)
	local manorCityRead = include("manorCityRead")
	local _fields = fguiHelper.get_fields(scrollInfo)
	local nodeNormal = _fields.Com_item
	local itemFields = fguiHelper.get_fields(nodeNormal)
	local Text_name = itemFields.Com_title
	local buildName = manorCityRead.getBuildName(self.tableBuildInfo.bid, self.tableBuildInfo.extra)
	_ENV = nil
	;(nil).buildName = buildName
	Text_name:setString(i18n("garden_text_08", nil))
	local Text_des = itemFields.Text_des
	Text_des:setString(manorCityRead.getBuildDes(self.tableBuildInfo.bid, self.tableBuildInfo.extra))
	local curLv = self.tableBuildInfo.blv
	self:createLabel(nodeNormal, tableBuildMore, curLv)
end
return BuildMoreInfoPanel
