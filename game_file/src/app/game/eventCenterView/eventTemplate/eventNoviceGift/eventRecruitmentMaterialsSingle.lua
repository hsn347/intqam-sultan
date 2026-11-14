local gametop = gModuleMgr.getObject("gametop")
local noviceGiftCtrl = gametop.playertop_:getModule("noviceGiftCtrl")
local eventQuestRead = include("eventQuestRead")
local eventRecruitmentMaterialsSingle = class("eventRecruitmentMaterialsSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventRecruitmentMaterialsSingle")
	end
	return target
end)
local MAX_AWARD_NUM = 5
function eventRecruitmentMaterialsSingle:ctor()
	self.awardArray, _ENV, self.data, _ENV = nil, nil, nil, nil
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	SoraDAutoSizeButtonText(self.Button_go, cc.size(120, 50))
	self.Button_go:setSwallowTouches(false)
	self.Text_des = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_des"))
	self.Text_schedule = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_schedule"))
	self.finishNode = SoraDGetChildByName(self, "Node_Finish")
	SoraDGetChildByName(self.finishNode, "Text_Finish"):setString(i18n("common_text_2601"))
	self.Button_go:setTitleText(i18n("common_text_1146"))
	self:commonSetting()
	self:createScroll()
end
function eventRecruitmentMaterialsSingle:initData(data, otherData)
	self.data = data
	self.view = otherData.view
	self.day = self.data.index
	if not self.data.alreadyCreate then
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		self.data.award = serviceFunctions.tableFormat(self.data.award, nil)
		self.data.alreadyCreate = true
	end
	local rightDay = noviceGiftCtrl:getCurrentDay()
	local color = "#be2828"
	if rightDay >= self.day then
		rightDay = self.day
		color = "#FFEBB9"
	end
	_ENV = nil
	;(nil).count = rightDay
	_ENV, _ENV, (nil).total = nil, self.day, self.day
	_ENV, self.day.count, (nil).color = nil, nil, color
	self.day.__default, (nil).color = nil, "#FFEBB9"
	self.Text_schedule:setString(_G.i18n_html("common_text_3683", nil, self.day))
	local isCanGet = noviceGiftCtrl:getCanReceiveByDay(self.day)
	self.Button_go:setBright(isCanGet)
	self.Button_go:setEnabled(isCanGet)
	self.finishNode:setVisible(false)
	self.Button_go:setVisible(true)
	if noviceGiftCtrl:isAlreadyReceiveByDay(self.day) then
		self.finishNode:setVisible(true)
		self.Button_go:setVisible(false)
	end
	_ENV = _G.i18n_html("common_text_3683", nil, self.day)
	_ENV, _ENV, _G.i18n_html("common_text_3683", nil, self.day).num = _G.i18n_html("common_text_3683", nil, self.day)
	_ENV, self.day.num, _G.i18n_html("common_text_3683", nil, self.day).color = _G.i18n_html("common_text_3683", nil, self.day)
	self.day.__default, _G.i18n_html("common_text_3683", nil, self.day).color = _G.i18n_html("common_text_3683", nil, self.day)
	self.Text_des:setString(i18n_html("king_road_01", _G.i18n_html("common_text_3683", nil, self.day)))
	self:setAward()
end
function eventRecruitmentMaterialsSingle:commonSetting()
	self.awardArray, _ENV = nil, nil
	SoraDChangeTextToHtml(self.Text_schedule)
	self.Button_go:addTouchEventListener(handler(self, self.btnClickCallBack))
end
function eventRecruitmentMaterialsSingle:createScroll()
	self.scrollView = ccui.ScrollView:create()
	self.scrollView:setAnchorPoint(0, 0.5)
	self.scrollView:setPosition(cc.p(15, 60))
	if SoraDFIsRA() then
		self.scrollView:setAnchorPoint(1, 0.5)
		self.scrollView:setPosition(cc.p(630, 60))
	end
	self.scrollView:setBounceEnabled(true)
	self.scrollView:setDirection(2)
	self.scrollView:addTo(self, 1)
	self.scrollView:setContentSize(cc.size(450, 100))
	self.scrollView:setSwallowTouches(false)
end
function eventRecruitmentMaterialsSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		noviceGiftCtrl:sendReceiveMsg()
	end
end
function eventRecruitmentMaterialsSingle:setAward()
	for i, v in ipairs(self.data.award) do
		if not self.awardArray[i] and i <= MAX_AWARD_NUM then
			self.awardArray[i] = include("commonItemAward").new()
			self.awardArray[i]:setScale(0.8)
			self.awardArray[i]:setBaseScale(1.0)
			self.awardArray[i]:setOwnView(self.view)
			self.awardArray[i]:setOwnScroll(self.ownScroll)
			if SoraDFIsRA() then
				self.awardArray[i]:setPosition(400 - (i - 1) * 90, 50)
			else
				self.awardArray[i]:setPosition(45 + (i - 1) * 90, 50)
			end
			self.awardArray[i]:addTo(self.scrollView)
		end
		if self.awardArray[i] then
			self.awardArray[i]:initData(v.id, v.count)
			if v.id == 900012 then
				self.awardArray[i]:showCoolSquare()
			else
				self.awardArray[i]:hideCoolSquare()
			end
			self.awardArray[i]:setVisible(i <= MAX_AWARD_NUM)
		end
	end
end
return eventRecruitmentMaterialsSingle
