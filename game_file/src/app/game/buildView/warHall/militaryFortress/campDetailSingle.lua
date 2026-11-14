local militaryFortressRead = include("militaryFortressRead")
local militaryFortressCtrl = SoraDGetCtrl("militaryFortressCtrl")
local campDetailSingle = class("campDetailSingle", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("campDetailSingle")
end)
function campDetailSingle:ctor(properties)
	self.itemSpace, _ENV = nil, nil
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.scrollBuff = SoraDGetChildByName(self, "ScrollView_Buff")
	self.scrollBuff = include("buffScrollView").new(self.scrollBuff)
	self.scrollBuff:setProportion(0.7)
	self.scrollBuff:setTouchEnabled(false)
	self.btnDetail = SoraDGetChildByName(self, "Button_Detail")
	self.btnDetail:addTouchEventListener(handler(self, self.btnDetailClick))
	self.spDetail = SoraDGetChildByName(self.btnDetail, "Sprite_Detail")
	self.textButtonDetail = SoraDGetChildByName(self.btnDetail, "Text_ButtonDetail")
	self.textButtonDetail = SoraDChangeTextToHtml(self.textButtonDetail)
	_ENV = handler(self, self.btnDetailClick)
	_ENV, _ENV, handler(self, self.btnDetailClick).commonStr = "common_text_1720", i18n("common_text_1720"), i18n("common_text_1720")
	;("common_text_1720").c = "true"
	i18n("common_text_1720").commonStr, ("common_text_1720").u = "common_text_1720", "true"
	self.textButtonDetail:setString(i18n_html("common_text_034", handler(self, self.btnDetailClick)))
	self.spDetail:setPositionX(100 + SoraDFPosX(self.textButtonDetail:getContentSize().width / 2 + 20, 0))
	self.nodeHeroSelect = SoraDGetChildByName(self, "Node_HeroSelect")
	self.imgIcon = SoraDGetChildByName(self, "icon_camp")
end
function campDetailSingle:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MILITARY_FORTRESS_REFRESH", handler(self, self.msgCallBack))
end
function campDetailSingle:initData(data, otherData)
	self.campType = data.campType
	self.fortessType = otherData.fortessType
	self.imgIcon:setSpriteFrame(self.campType == 1 and "frame_fortress_flag_cf.png" or "frame_fortress_flag_hj.png")
	self.textTitle:setString(i18n(militaryFortressRead.getCampTitle(self.campType)))
	self.textTips:setString(i18n(self.campType == 2 and "fortress_text_02" or "fortress_text_03"))
	self:initHeroNode()
	self:initBuffScroll()
end
function campDetailSingle:initHeroNode()
	self.buffConfig = militaryFortressRead.getBuffConfig(self.campType, self.fortessType)
	local heroList = militaryFortressCtrl:getHeroList(self.fortessType, self.campType)
	for i, buffID in ipairs(self.buffConfig) do
		local single
		if self.itemSpace[i] then
			single = self.itemSpace[i]
		else
			single = include("heroLockItem").new()
			single:addTo(self.nodeHeroSelect)
			single:setRemoveClick(handlerEx(self, self.removeHeroFun, i))
			single:setAddClick(handlerEx(self, self.setAddCallBack, i))
			single:setScale(0.7)
			table.insert(self.itemSpace, single)
		end
		local str, _ = militaryFortressRead.getTitleAndValueStr(buffID, 0)
		single:addNameText(str)
		if heroList[tostring(i)] then
			single:initData(gHeroItemLockStyle.have, heroList[tostring(i)])
		else
			single:initData(gHeroItemLockStyle.none)
		end
	end
	SoraDautoSortPos(self.nodeHeroSelect, 3, 1, cc.size(95, 95), SoraDFIsRA())
end
function campDetailSingle:initBuffScroll()
	local buffList = militaryFortressCtrl:getBuffList(self.fortessType, self.campType)
	local height = math.max(150 / table.nums(buffList), 30)
	militaryFortressCtrl = nil
	;(nil).scroll = self.scrollBuff
	;(nil).view = self
	self.scrollBuff:updateScrollView(cc.size(205, height), buffList, 1, nil)
	self.btnDetail:setVisible(table.nums(buffList) > 5)
end
function campDetailSingle:btnDetailClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local panel = SoraDCreatePanel("campHeroDetailBuffView")
		panel:initData(self.fortessType, self.campType)
		panel:show()
	end
end
function campDetailSingle:removeHeroFun(pos, heroID)
	militaryFortressCtrl = nil
	;(nil).fortessType = self.fortessType
	;(nil).campType = self.campType
	;(nil).pos = pos
	;(nil).heroID = heroID
	militaryFortressCtrl:reqMilitaryFortessCancelHero(nil)
end
function campDetailSingle:setAddCallBack(pos, heroID)
	local heroIDList = militaryFortressCtrl:getChooseHeroList(self.fortessType, self.campType, pos)
	if heroIDList and next(heroIDList) then
		local panel = SoraDCreatePanel("militaryFortressHeroSelectView")
		panel:initData(self.campType, self.fortessType, pos)
		panel:show()
	else
		militaryFortressCtrl = self.campType
		self.campType.var = i18n(string.format("common_text_14%d", self.fortessType + 2))
		SoraDShowMsgBox(i18n("fortress_text_17", self.campType), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
			if MSGBOX_CALLBACK_YES == eventType then
				SoraDRemoveAllPanelFromManager()
				uiManager:show("newHeroListView")
			end
		end)
	end
end
function campDetailSingle:msgCallBack(target, data)
	self:initHeroNode()
	self:initBuffScroll()
end
return campDetailSingle
