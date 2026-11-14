local gametop = gModuleMgr.getObject("gametop")
local kingOfGloryCtrl = gametop.playertop_:getModule("kingOfGloryCtrl")
local scrollNode = include("scrollNode")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
_ENV = "lordInfoCtrl"
;("lordInfoCtrl").UNLOCKED = 0
;("lordInfoCtrl").LOCKED = 1
local ("lordInfoCtrl").RECEVIED, RECEVIE_TYPE = 2, "lordInfoCtrl"
local kingOfGlorySingle = class("kingOfGlorySingle", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("kingOfGlorySingle")
end)
function kingOfGlorySingle:ctor()
	self:createUI()
	self.scheduBgColor = "#D7C39B"
	self.scheduColor = "#be2828"
	self.scheduValeColor = "#d7c39b"
	self.Node_Award = SoraDGetChildByName(self, "Node_Award")
	self.btn_operate = SoraDGetChildByName(self, "btn_operate")
	self.text_progress_title = SoraDGetChildByName(self, "text_progress_title")
	self.text_progress_title = _G.SoraDChangeTextToHtml(self.text_progress_title)
	self.text_progress_value = SoraDGetChildByName(self, "text_progress_value")
	self.text_progress_total = SoraDGetChildByName(self, "text_progress_total")
	self.text_progress_title:setContentSize(cc.size(500, 40))
	self.text_title = SoraDGetChildByName(self, "text_title")
	self.Image_got = SoraDGetChildByName(self, "Image_got")
	self.Text_got = SoraDGetChildByName(self, "Text_got")
	self.Text_got:setString(i18n("common_text_1892"))
	self.btn_operate:addTouchEventListener(handler(self, self.onGetReward))
	self.btn_operate = scrollNode.new(self.btn_operate)
	self.btn_operate:setSwallowTouches(false)
	self.btn_operate:setTouchEnabled(true)
	self.awardItems, _ENV = self.btn_operate.setTouchEnabled, self.btn_operate.setTouchEnabled
end
function kingOfGlorySingle:setFlyTargetPos(targetPos)
	self.targetPos = targetPos
end
function kingOfGlorySingle:createUI()
end
function kingOfGlorySingle:reset()
	self.btn_operate:setTouchEnabled(true)
	SoraDSetNodeGray(self.btn_operate, false)
	SoraDCloseLoading(self.btn_operate)
end
function kingOfGlorySingle:initData(data, otherData)
	self:reset()
	self.cfgData = data
	self.scroll = otherData.scroll
	local tablePlayerInfo = lordInfoCtrl:getLordInfo()
	local nowPower = tablePlayerInfo.fcInfo.totalFc
	local needPower = data.power
	lordInfoCtrl = nil
	;(nil).num = SoraDConvertNumberWithUnit(data.power)
	self.text_title:setString(i18n("kingglory_text_03", nil))
	self:setScheduleText(nowPower, needPower)
	local align = false
	local lordInfoCtrl, nodeArray = self, self
	if SoraDFIsRA() then
		_UPVALUE3_ = SoraDFIsRA()
		RECEVIE_TYPE, nodeArray, SoraDFIsRA()[1] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_value
		RECEVIE_TYPE, nodeArray, SoraDFIsRA()[2] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_total
		RECEVIE_TYPE, nodeArray, SoraDFIsRA()[3] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_title
		paddingArray, SoraDFIsRA()[1] = SoraDFIsRA(), 0
		paddingArray, SoraDFIsRA()[2] = SoraDFIsRA(), 5
		align = false
	else
		_UPVALUE3_ = SoraDFIsRA()
		RECEVIE_TYPE, nodeArray, SoraDFIsRA()[1] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_total
		RECEVIE_TYPE, nodeArray, SoraDFIsRA()[2] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_value
		RECEVIE_TYPE, nodeArray, SoraDFIsRA()[3] = SoraDFIsRA(), SoraDFIsRA(), self.text_progress_title
		paddingArray, SoraDFIsRA()[1] = SoraDFIsRA(), 0
		paddingArray, SoraDFIsRA()[2] = SoraDFIsRA(), 5
		align = true
	end
	SoraDAlignNodeArray(nodeArray, align, paddingArray)
	self.btn_operate:setScroll(otherData.scroll)
	self.btn_operate:setVisible(true)
	RECEVIE_TYPE = true
	;(true)[1] = "id"
	;(true)[2] = "count"
	local rewards = serviceFunctions.tableFormat(data.reward, true)
	for i = 1, 6 do
		local reward = rewards[i]
		local item = self.awardItems[i]
		if item then
			item:setVisible(reward ~= nil)
		end
		if reward and not item then
			item = SoraDPopItemAward()
			item:setScale(0.7)
			item:setOwnScroll(otherData.scroll)
			item:setPositionY(0)
			item:addTo(self.Node_Award)
			item:setBaseScale(1.0)
			table.insert(self.awardItems, item)
		end
		if reward then
			item:initData(reward.id, reward.count)
		end
	end
	SoraDToCenter(self.Node_Award, 84, SoraDFIsRA())
	if data.recevie_type == RECEVIE_TYPE.UNLOCKED then
		self.btn_operate:setVisible(true)
		SoraDSetNodeGray(self.btn_operate, false)
		self.btn_operate:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
		self.btn_operate:setTitleText(i18n("common_text_1146"))
		self.Image_got:setVisible(false)
		self.Text_got:setVisible(false)
	elseif data.recevie_type == RECEVIE_TYPE.RECEVIED then
		self.btn_operate:setVisible(false)
		self.Image_got:setVisible(true)
		self.Text_got:setVisible(true)
	elseif data.recevie_type == RECEVIE_TYPE.LOCKED then
		self.btn_operate:loadTextures("btn_yellow_normal_01.png", "", "", ccui.TextureResType.plistType)
		self.btn_operate:setTitleText(i18n("common_text_477"))
		self.Image_got:setVisible(false)
		self.Text_got:setVisible(false)
	end
end
function kingOfGlorySingle:setScheduleText(nowPower, needPower)
	local count = nowPower
	local total = needPower
	count = math.min(count, total)
	if self.cfgData.recevie_type == RECEVIE_TYPE.RECEVIED then
		scheduTotalColor = self.scheduBgColor
		scheduCountColor = self.scheduBgColor
	elseif self.cfgData.recevie_type == RECEVIE_TYPE.LOCKED then
		scheduTotalColor = self.scheduBgColor
		scheduCountColor = self.scheduColor
	elseif self.cfgData.recevie_type == RECEVIE_TYPE.UNLOCKED then
		scheduTotalColor = self.scheduBgColor
		scheduCountColor = self.scheduValeColor
	end
	_ENV = count
	count.color = scheduCountColor
	local countStr = SoraDWrapHtmlTagByStyle(SoraDConvertNumberWithUnit(count), count)
	_ENV = "%s"
	;("%s").color = scheduTotalColor
	local totalStr = SoraDWrapHtmlTagByStyle(string.format("%s", SoraDConvertNumberWithUnit(total)), "%s")
	local value = string.format("%s%s", countStr, totalStr)
	value = _pq(value)
	_ENV = SoraDConvertNumberWithUnit(total)
	SoraDConvertNumberWithUnit(total).count = countStr
	_ENV, _ENV, SoraDConvertNumberWithUnit(total).total = SoraDConvertNumberWithUnit(total)
	SoraDConvertNumberWithUnit(total).__default, SoraDConvertNumberWithUnit(total).color = SoraDConvertNumberWithUnit(total)
	print("a==========" .. _G.i18n_html("common_text_3683", SoraDConvertNumberWithUnit(total)))
	_ENV = SoraDConvertNumberWithUnit(total)
	SoraDConvertNumberWithUnit(total).count = countStr
	_ENV, _ENV, SoraDConvertNumberWithUnit(total).total = SoraDConvertNumberWithUnit(total)
	SoraDConvertNumberWithUnit(total).__default, SoraDConvertNumberWithUnit(total).color = SoraDConvertNumberWithUnit(total)
	self.text_progress_title:setString(_G.i18n_html("common_text_3683", SoraDConvertNumberWithUnit(total)))
end
function kingOfGlorySingle:onGetReward(sender, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		if self.cfgData.recevie_type == RECEVIE_TYPE.LOCKED then
			_ENV = nil
			;(nil).num = SoraDConvertNumberWithUnit(self.cfgData.power)
			SoraDShowMsgTip(i18n("Newbie_task_content_38", nil))
			_ENV = i18n("Newbie_task_content_38", nil)
			i18n("Newbie_task_content_38", nil).msg = "MESSAGE_KING_OF_GLORY_ON_CLOSE"
			SoraDSendMessage(i18n("Newbie_task_content_38", nil))
		else
			kingOfGloryCtrl:reqGetReward(self.cfgData.index)
		end
	end
end
return kingOfGlorySingle
