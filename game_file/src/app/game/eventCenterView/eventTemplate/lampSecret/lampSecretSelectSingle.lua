local lampSecretCtrl = SoraDGetCtrl("lampSecretCtrl")
local lampSecretRead = include("lampSecretRead")
local lampSecretSelectSingle = class("lampSecretSelectSingle", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("lampSecretSelectSingle")
end)
function lampSecretSelectSingle:ctor(properties)
	self.awardNodeList, _ENV, self.chooseIndex, _ENV, self.chooseNum = nil, nil, nil, nil, 0
	self.chooseHandler = nil
	self.bgTitle = SoraDGetChildByName(self, "frame_qdmy_title")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.textTitle = SoraDChangeTextToHtml(self.textTitle)
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.nodeCommonItemAward = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_item")
	self.imgAwardBg = SoraDGetChildByName(self, "Image_AwardBg")
end
function lampSecretSelectSingle:initData(groupType, parent)
	self.parentView = parent
	self.groupType = groupType
	local config = lampSecretRead:getChooseConfig(groupType)
	self.maxChooseNum = config.maxNum
	self.titleStr = config.title
	self.bgTitle:setSpriteFrame(config.bgTitle)
	lampSecretRead = nil
	;(nil).var1 = self.chooseNum
	lampSecretRead, lampSecretRead, (nil).var2 = nil, self.maxChooseNum, self.maxChooseNum
	lampSecretRead, self.maxChooseNum.var1, (nil).color = nil, nil, self.chooseNum < self.maxChooseNum and "#E90000" or "#FFD555"
	self.maxChooseNum.__default, (nil).color = nil, "#FFD555"
	self.textTitle:setString(i18n_html(self.titleStr, nil, self.maxChooseNum))
	self.rewardList = lampSecretRead.getGroupInfo(lampSecretCtrl:getClassType(), groupType)
	self.height = 50 + math.ceil(table.nums(self.rewardList) / 4) * 100
	self.imgAwardBg:setContentSize(cc.size(514, self.height - 50))
	self.imgAwardBg:setPositionY(-(self.height + 40) / 2)
	self:initAwardNode()
end
function lampSecretSelectSingle:initAwardNode()
	for _, itemInfo in ipairs(self.rewardList) do
		local single = self.nodeCommonItemAward:clone()
		single:addTo(self.nodeAward)
		single = include("commonItemAward").new(single)
		single.iconChoose = SoraDGetChildByName(single, "icon_Choose")
		local isChoosed = lampSecretCtrl:isItemSelected(itemInfo.index)
		if isChoosed then
			table.insert(self.chooseIndex, itemInfo.index)
			self.chooseNum = self.chooseNum + 1
		end
		single.iconChoose:setVisible(isChoosed)
		single:setName("nodeCommonItemAward")
		single:setOwnScroll(self:getParent():getParent())
		single:setOwnView(self.parentView)
		single:setHandle(handlerEx(self, self.btnChooseItem, itemInfo.index))
		single:initData(itemInfo.item[1], itemInfo.item[2])
		table.insert(self.awardNodeList, single)
	end
	self:setOtherAwardGray(self.chooseNum >= self.maxChooseNum)
	SoraDautoSortPos(self.nodeAward, 4, SoraDFIsRA() and 2 or 0, cc.size(100, 100), SoraDFIsRA())
	self.nodeAward:setPositionY(-(self.height + 40) / 2)
	_ENV = cc.size(100, 100)
	cc.size(100, 100).var1 = self.chooseNum
	_ENV, _ENV, cc.size(100, 100).var2 = SoraDFIsRA()
	_ENV, self.maxChooseNum.var1, SoraDFIsRA().color = SoraDFIsRA()
	self.maxChooseNum.__default, SoraDFIsRA().color = SoraDFIsRA()
	self.textTitle:setString(i18n_html(self.titleStr, cc.size(100, 100), self.maxChooseNum))
	self.chooseHandler(self.parentView, self.chooseIndex, self.groupType)
end
function lampSecretSelectSingle:btnChooseItem(index, target)
	print(target, eventType, itemID)
	local isChoosed, i = self:isChoosed(index)
	if isChoosed then
		table.remove(self.chooseIndex, i)
		target:getParent():getParent().iconChoose:setVisible(false)
		self.chooseNum = self.chooseNum - 1
		_ENV = nil
		;(nil).var1 = self.chooseNum
		_ENV, _ENV, (nil).var2 = nil, self.maxChooseNum, self.maxChooseNum
		_ENV, self.maxChooseNum.var1, (nil).color = nil, nil, self.chooseNum < self.maxChooseNum and "#E90000" or "#FFD555"
		self.maxChooseNum.__default, (nil).color = nil, "#FFD555"
		self.textTitle:setString(i18n_html(self.titleStr, nil, self.maxChooseNum))
		self:setOtherAwardGray()
		self.chooseHandler(self.parentView, self.chooseIndex, self.groupType)
		return
	end
	if self.chooseNum >= self.maxChooseNum then
		_ENV = self.groupType
		self.groupType.num = self.maxChooseNum
		SoraDShowMsgTip(i18n("Lamp_secret_text_03", self.groupType))
	else
		target:getParent():getParent().iconChoose:setVisible(true)
		table.insert(self.chooseIndex, index)
		self.chooseNum = self.chooseNum + 1
		_ENV = i18n("Lamp_secret_text_03", self.groupType)
		i18n("Lamp_secret_text_03", self.groupType).var1 = self.chooseNum
		_ENV, _ENV, i18n("Lamp_secret_text_03", self.groupType).var2 = i18n("Lamp_secret_text_03", self.groupType)
		_ENV, self.maxChooseNum.var1, i18n("Lamp_secret_text_03", self.groupType).color = i18n("Lamp_secret_text_03", self.groupType)
		self.maxChooseNum.__default, i18n("Lamp_secret_text_03", self.groupType).color = i18n("Lamp_secret_text_03", self.groupType)
		self.textTitle:setString(i18n_html(self.titleStr, i18n("Lamp_secret_text_03", self.groupType)))
		self:setOtherAwardGray(self.chooseNum >= self.maxChooseNum)
		self.chooseHandler(self.parentView, self.chooseIndex, self.groupType)
	end
end
function lampSecretSelectSingle:setOtherAwardGray(isShowGray)
	for i, v in ipairs(self.awardNodeList) do
		v:setGray(not v.iconChoose:isVisible() and isShowGray)
	end
end
function lampSecretSelectSingle:isChoosed(index)
	for i, v in ipairs(self.chooseIndex) do
		if v == index then
			return true, i
		end
	end
	return false
end
function lampSecretSelectSingle:getHeight()
	return self.height
end
function lampSecretSelectSingle:setChooseHandle(handle)
	self.chooseHandler = handle
end
return lampSecretSelectSingle
