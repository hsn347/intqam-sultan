local remainsWarRead = include("remainsWarRead")
local remainsWarltCtrl = include("remainsWarltCtrl")
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local remainsWarResultSingle = class("remainsWarResultSingle", function(target)
	return target
end)
function remainsWarResultSingle:ctor()
	self.listNode, _ENV, self.scrollItems, _ENV = nil, nil, nil, nil
	self.single = SoraDGetChildByName(self, "Node_single")
	self.single:setVisible(false)
	table.insert(self.listNode, self.single)
	self.tableSingleData, _ENV = table.insert, table.insert
	local remainsWarUtil = include("remainsWarUtil")
	self.isXianXia = remainsWarUtil.checkIsInRemainsXianXia()
end
function remainsWarResultSingle:initData(data, isShare)
	self.tableSingleData = data
	self.isShare = isShare
	self:updateNodeList()
end
function remainsWarResultSingle:getSingle()
	local single
	if #self.listNode > 0 then
		single = table.remove(self.listNode)
	else
		single = self.single:clone()
		single:addTo(self)
	end
	single:setVisible(true)
	return single
end
function remainsWarResultSingle:recycleSingle()
	for _, v in ipairs(self.scrollItems) do
		v:setVisible(false)
		table.insert(self.listNode, v)
	end
	self.scrollItems, _ENV = ipairs(self.scrollItems)
end
function remainsWarResultSingle:setSingleView(single, headData)
	local selfID = lordInfoCtrl:getLordInfo().base.uid
	local isSelf = headData.uid and selfID == headData.uid
	local imageSelfBg = SoraDGetChildByName(single, "Image_self_bg")
	imageSelfBg:setVisible(isSelf)
	local iconhead = SoraDGetChildByName(single, "icon_head")
	SoraDGetHeadFromManager(iconhead, headData.headid, headData.avatar)
	local colorText = remainsWarRead.getWarStatusColor(self.tableSingleData.isWin)
	local name = headData.nickName
	local allianceAbbr = headData.allianceAbbr
	if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
		lordInfoCtrl = nil
		;(nil).abbr = allianceAbbr
		;(nil).name = headData.nickName
		name = i18n("common_text_186", nil)
	end
	if headData.kid then
		name = name .. "#" .. tostring(headData.kid)
	end
	local txtName = SoraDGetChildByName(single, "Text_name")
	txtName:setString(name)
	txtName:setColor(colorText)
	local txtScoreNum = SoraDGetChildByName(single, "Text_score_num")
	local strScoreNum = string.formatnumberthousands(headData.gradePoints)
	txtScoreNum:setColor(colorText)
	if self.isXianXia then
		lordInfoCtrl = nil
		;(nil).num = strScoreNum
		txtScoreNum:setString(i18n("common_text_2556", nil))
	else
		lordInfoCtrl = i18n("common_text_2556", nil)
		i18n("common_text_2556", nil).num = strScoreNum
		txtScoreNum:setString(i18n("remains_text_128", i18n("common_text_2556", nil)))
	end
	if self.isXianXia then
		SoraDGetChildByName(single, "Node_score_font"):setVisible(false)
	else
		local score = remainsWarltCtrl.getRuinsWarGrade(headData.gradePoints)
		local strScore = remainsWarRead.getScoreName(score)
		local txtScoreFont = SoraDGetChildByName(single, "Text_score_font")
		txtScoreFont:setString(strScore)
	end
	local txtArmyNum = SoraDGetChildByName(single, "Text_army_num")
	local strArmyNum = string.formatnumberthousands(headData.killArmyFc)
	lordInfoCtrl = i18n("remains_text_128", i18n("common_text_2556", nil))
	i18n("remains_text_128", i18n("common_text_2556", nil)).power = strArmyNum
	txtArmyNum:setString(i18n("remains_text_169", i18n("remains_text_128", i18n("common_text_2556", nil))))
	txtArmyNum:setColor(colorText)
	local txtMonsterNum = SoraDGetChildByName(single, "Text_monster_num")
	if self.isXianXia then
		txtMonsterNum:setVisible(false)
	else
		local strMonsterNum = string.formatnumberthousands(headData.killNpcNum)
		lordInfoCtrl = i18n("remains_text_169", i18n("remains_text_128", i18n("common_text_2556", nil)))
		i18n("remains_text_169", i18n("remains_text_128", i18n("common_text_2556", nil))).num = strMonsterNum
		txtMonsterNum:setString(i18n("remains_text_129", i18n("remains_text_169", i18n("remains_text_128", i18n("common_text_2556", nil)))))
		txtMonsterNum:setColor(colorText)
	end
	local txtAttackNum = SoraDGetChildByName(single, "Text_attack_num")
	if self.isXianXia then
		txtAttackNum:setVisible(false)
	else
		local strAttackNum = string.formatnumberthousands(headData.atkCityWinNum or 0)
		lordInfoCtrl = i18n("remains_text_129", i18n("remains_text_169", i18n("remains_text_128", i18n("common_text_2556", nil))))
		i18n("remains_text_129", i18n("remains_text_169", i18n("remains_text_128", i18n("common_text_2556", nil)))).count = strAttackNum
		txtAttackNum:setString(i18n("common_text_4406", i18n("remains_text_129", i18n("remains_text_169", i18n("remains_text_128", i18n("common_text_2556", nil))))))
		txtAttackNum:setColor(colorText)
	end
	if self.isShare then
		SoraDSetTextWidthHeight(txtScoreNum, cc.size(100, 30))
		SoraDSetTextWidthHeight(txtArmyNum, cc.size(160, 30))
		SoraDSetTextWidthHeight(txtMonsterNum, cc.size(160, 30))
		SoraDSetTextWidthHeight(txtAttackNum, cc.size(160, 30))
	else
		SoraDSetTextWidthHeight(txtArmyNum, cc.size(180, 42))
	end
	local spMVP = SoraDGetChildByName(single, "Sprite_mvp")
	spMVP:setVisible(headData.isMVP)
	if headData.isMVP then
		local remainsWarUtil = include("remainsWarUtil")
		remainsWarUtil.addMvpEffect(spMVP)
		remainsWarUtil.addMVPAnimation(self, spMVP)
	end
	if not self.isShare and not isSelf and not SoraDGetCtrl("contactCtrl"):isFriend(headData.uid) then
		if not single.btnAdduser then
			local button = ccui.Button:create("icon_yjzz_adduser_01.png", nil, nil, ccui.TextureResType.plistType)
			button:addTo(SoraDGetChildByName(single, "Node_head"))
			button:setPosition(30, -30)
			button:addTouchEventListener(handler(self, self.onBtnAdduserClick))
			single.btnAdduser = button
		end
		single.btnAdduser:setTag(headData.uid)
		single.btnAdduser:setVisible(true)
	elseif single.btnAdduser then
		single.btnAdduser:setVisible(false)
	end
end
function remainsWarResultSingle:onBtnAdduserClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local headData
		if not self.tableSingleData.members then
			_ENV = self.tableSingleData.members
		end
		for i, v in ipairs(self.tableSingleData.members) do
			if v.uid == button:getTag() then
				headData = clone(v)
				break
			end
		end
		if headData then
			headData.abbr = headData.allianceAbbr
			headData.cityLevel = CASTLE_LV27_LIMITED
			_ENV = nil
			;(nil).data = headData
			;(nil).isIgnore = true
			;(nil).handle = function()
				button:setVisible(false)
			end
			uiManager:show("friendApplyView", nil)
		end
	end
end
local SINGLE_HEIGHT = 170
function remainsWarResultSingle:updateNodeData()
	if not self.tableSingleData.members then
		_ENV = self.tableSingleData.members
	end
	for i, v in ipairs(self.tableSingleData.members) do
		local single = self:getSingle()
		self:setSingleView(single, v)
		single:setPositionY(-(i - 1) * SINGLE_HEIGHT)
		table.insert(self.scrollItems, single)
	end
end
function remainsWarResultSingle:updateNodeList()
	self:recycleSingle()
	self:updateNodeData()
end
function remainsWarResultSingle:getHeight()
	return #self.scrollItems * SINGLE_HEIGHT + 10
end
return remainsWarResultSingle
