local gametop = gModuleMgr.getObject("gametop")
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
local elementWidth = 560
local fontColor = cc.c3b(215, 195, 155)
local subTitleColor = cc.c3b(255, 200, 100)
local createNode_text = function(elementCfg)
	local node = display.newNode()
	local param = elementCfg.param
	local labelDes = ccui.Text:create()
	labelDes:setFontSize(20)
	labelDes:setColor(fontColor)
	labelDes:setString(i18n(param.title) or "todo")
	labelDes:setTextHorizontalAlignment(SoraDFLabelR())
	SoraDGetAutoHeightLabel(labelDes, 550)
	node:setContentSize(cc.size(elementWidth, labelDes:getContentSize().height + 20))
	labelDes:setAnchorPoint(cc.p(0.5, 0.0))
	labelDes:setPosition(cc.p(elementWidth / 2, 10.0))
	node:addChild(labelDes)
	return node
end
local commonInstruction = class("commonInstruction", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("commonInstruction")
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function commonInstruction:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_3578"))
	self.Top_Size_ScrollView_info = SoraDGetChildByName(self, "Top_Size_ScrollView_info")
	self.Top_Size_ScrollView_info:setPositionY(9)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeSingle = SoraDGetChildByName(self, "Node_single")
	self.nodeSingle:setVisible(false)
	_ENV, self.nodeSubTitle = SoraDGetChildByName(self, "Node_subTitle"), SoraDGetChildByName(self, "Node_subTitle")
	SoraDGetChildByName(self, "Node_subTitle").title_2 = handler(self, self.createNode_title_2)
	SoraDGetChildByName(self, "Node_subTitle").sheet_2 = handler(self, self.createNode_sheet_2)
	self.nodeCreateFuncTb, SoraDGetChildByName(self, "Node_subTitle").text = SoraDGetChildByName(self, "Node_subTitle"), createNode_text
	self:init()
end
function commonInstruction:init(data)
	_ENV, playerMobilizationCtrl = nil, nil
	_ENV, (nil).nodeType = nil, "text"
	;(nil).param, (nil).title = nil, "common_text_3576"
	local (nil)[1], contentConfig
	if SoraDFIsRA() then
		_ENV = nil
		_ENV, (nil).nodeType = nil, "title_2"
		;(nil).title1 = "common_text_3689"
		;(nil).param, (nil).title2 = nil, "common_text_3579"
		table.insert(contentConfig, nil)
	else
		_ENV = nil
		_ENV, (nil).nodeType = nil, "title_2"
		;(nil).title1 = "common_text_3579"
		;(nil).param, (nil).title2 = nil, "common_text_3689"
		table.insert(contentConfig, nil)
	end
	local matchLv, currentScore
	local allianceMobiInfo = playerMobilizationCtrl:getAllianceMobiInfo()
	if allianceMobiInfo then
		matchLv = allianceMobiInfo.matchlev
		currentScore = allianceMobiInfo.score
	end
	matchLv = matchLv or 1
	currentScore = currentScore or 0
	local myStage, myMaxScore = mobilizationltCtrl:getCurrentStageMax(currentScore, matchLv)
	local stateAward = mobilizationltCtrl:getStageAward()
	for i, v in ipairs(stateAward) do
		if v.matchlev ~= matchLv and matchLv < v.matchlev then
			break
		end
		if v.matchlev == matchLv then
			if myStage == v.stage then
				if SoraDFIsRA() then
					_ENV = nil
					_ENV, (nil).nodeType = nil, "sheet_2"
					;(nil).title1 = v.needscore
					;(nil).title2 = v.stage
					;(nil).param, (nil).textColor = nil, whiteColor
					table.insert(contentConfig, nil)
				else
					_ENV = nil
					_ENV, (nil).nodeType = nil, "sheet_2"
					;(nil).title1 = v.stage
					;(nil).title2 = v.needscore
					;(nil).param, (nil).textColor = nil, whiteColor
					table.insert(contentConfig, nil)
				end
			elseif SoraDFIsRA() then
				_ENV = nil
				_ENV, (nil).nodeType = nil, "sheet_2"
				;(nil).title1 = v.needscore
				;(nil).param, (nil).title2 = nil, v.stage
				table.insert(contentConfig, nil)
			else
				_ENV = nil
				_ENV, (nil).nodeType = nil, "sheet_2"
				;(nil).title1 = v.stage
				;(nil).param, (nil).title2 = nil, v.needscore
				table.insert(contentConfig, nil)
			end
		end
	end
	self:initWithConfig(contentConfig)
end
function commonInstruction:initWithConfig(contentCfg)
	local scrollWidth = self.Top_Size_ScrollView_info:getContentSize().width
	local scrollHeight = self.Top_Size_ScrollView_info:getContentSize().height
	local totalHeight = 0
	local scrollInner = self.Top_Size_ScrollView_info:getInnerContainer()
	local _ENV, tbElements = self.Top_Size_ScrollView_info, self.Top_Size_ScrollView_info
	for i, elementCfg in ipairs(contentCfg) do
		local element = self:createElement(elementCfg)
		if elementCfg.nodeType == "text" then
			element:addTo(self.Top_Size_ScrollView_info)
		end
		tbElements[i] = element
		element:setAnchorPoint(cc.p(0.5, 0))
		element:setPosition(cc.p(elementWidth / 2, 0))
		if element:getContentSize().height ~= 0 then
			totalHeight = totalHeight + element:getContentSize().height
		else
			totalHeight = totalHeight + 34
		end
	end
	if scrollHeight > totalHeight then
		totalHeight = scrollHeight
	end
	self.Top_Size_ScrollView_info:setInnerContainerSize(cc.size(scrollWidth, totalHeight))
	local accuHeight = 0
	for i, node in ipairs(tbElements) do
		if node:getContentSize().height ~= 0 then
			accuHeight = accuHeight + node:getContentSize().height
		else
			accuHeight = accuHeight + 34
		end
		node:setPositionY(totalHeight - accuHeight)
	end
	self.Top_Size_ScrollView_info:scrollToTop(0.1, false)
end
function commonInstruction:createElement(elementCfg)
	print("create ----")
	local nodeType = elementCfg.nodeType
	local param = elementCfg.param
	local funcCreateNode = self.nodeCreateFuncTb[nodeType]
	if funcCreateNode then
		return funcCreateNode(elementCfg)
	end
end
function commonInstruction:createNode_title_2(elementCfg)
	local node = self.nodeSubTitle
	local param = elementCfg.param
	SoraDGetChildByName(self.nodeSubTitle, "Text_score"):setString(i18n(param.title1))
	SoraDGetChildByName(self.nodeSubTitle, "Text_score"):setColor(subTitleColor)
	SoraDGetChildByName(self.nodeSubTitle, "Text_state"):setString(i18n(param.title2))
	SoraDGetChildByName(self.nodeSubTitle, "Text_state"):setColor(subTitleColor)
	return node
end
function commonInstruction:createNode_sheet_2(elementCfg)
	local node = self.nodeSingle:clone()
	local param = elementCfg.param
	local textColor = param.textColor or fontColor
	if param.textColor then
		node:getChildByName("Image_hightLight"):setVisible(true)
		node:getChildByName("Image_commonBg"):setVisible(false)
	else
		node:getChildByName("Image_hightLight"):setVisible(false)
		node:getChildByName("Image_commonBg"):setVisible(true)
	end
	if SoraDFIsRA() and param.title2 % 2 == 0 then
		node:getChildByName("Image_commonBg"):setVisible(false)
	elseif not SoraDFIsRA() and param.title1 % 2 == 0 then
		node:getChildByName("Image_commonBg"):setVisible(false)
	end
	node:getChildByName("Text_score"):setString(param.title1)
	node:getChildByName("Text_state"):setString(param.title2)
	node:getChildByName("Text_score"):setColor(textColor)
	node:getChildByName("Text_state"):setColor(textColor)
	node:setVisible(true)
	node:addTo(self.Top_Size_ScrollView_info)
	return node
end
return commonInstruction
