local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local gametop = gModuleMgr.getObject("gametop")
local djCtrl = gametop.playertop_:getModule("djCtrl")
local DjView = class("djView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("djView")
	end
	return target
end)
function DjView:ctor()
	self.ccsNightBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonChatBg_node", true)
	self.scrollView = SoraDGetExtendChildFromCCSByName(self, "CCS_djScrollView_scroll")
	self.nodeHead = SoraDGetExtendChildFromCCSByName(self, "CCS_djHead_head")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_chat")
	self.bottomViewNode = SoraDGetExtendChildFromCCSByName(self, "CCS_djBottomView_bottom")
	self.nodeTitle:setTitle(i18n("Anchor_btn_01"))
	self:initData()
	self.oriScrollViewPos = cc.p(self.scrollView:getPosition())
	self.oriBottomViewPos = cc.p(self.bottomViewNode:getPosition())
	self.oriChatPrizePageViewPosY = -270
	self.bottomViewNode:setChatDelegate(self)
end
function DjView:openPrizeUI(target, data)
	self.isOpenPrize = true
	local offsetY = math.abs(self.oriChatPrizePageViewPosY)
	local deltaTextHeight = 0
	_ENV = nil
	;(nil).duration = 0.25
	;(nil).offsetY = offsetY
	;(nil).isMoveTo = true
	self:onOffsetUI(nil)
	local actMove9 = cca.moveTo(0.25, 0, offsetY)
	self.ccsNightBg:stopAllActions()
	self.ccsNightBg:runAction(actMove9)
end
function DjView:hidePrizeUI(target, data)
	_ENV = nil
	;(nil).duration = 0.25
	;(nil).offsetY = 0
	self:onOffsetUI(nil)
	local actMove9 = cca.moveTo(0.25, 0, 0)
	self.ccsNightBg:stopAllActions()
	self.ccsNightBg:runAction(actMove9)
end
function DjView:onOffsetUI(data)
	dump(data, "chatContentView:onOpenEmotionUI(data)")
	local duration = data.duration or 0.25
	local isMoveTo = data.isMoveTo
	local offsetY = data.offsetY
	local actMoveTo1 = cca.moveTo(0.25, self.oriBottomViewPos.x, self.oriBottomViewPos.y + offsetY)
	self.bottomViewNode:stopAllActions()
	self.bottomViewNode:runAction(actMoveTo1)
	local actMoveTo = cca.moveTo(duration, self.oriScrollViewPos.x, self.oriScrollViewPos.y + offsetY)
	self.scrollView:stopAllActions()
	self.scrollView:runAction(actMoveTo)
end
function DjView:initData()
	self.ccsNightBg:updateTheme()
	self.bottomViewNode:initData(gChatDJShowType.DJ_VIEW)
	self.nodeHead:initData(nil, gChatDJShowType.DJ_VIEW)
	_ENV = nil
	;(nil).chatChannel = gChatChannel.DJ
	;(nil).chatSet = gChatSet.TOTAL
	;(nil).showType = gChatDJShowType.DJ_VIEW
	;(nil).headNode = self.nodeHead
	self.scrollView:initWithChatChannel(nil)
end
function DjView:close(ref, type)
	if type == ccui.TouchEventType.ended then
		if djCtrl.isBroadcastDJ then
			_ENV = nil
			;(nil).time = self.bottomViewNode.labelTime:getString()
			SoraDShowMsgBox(i18n("Anchor_text_33", nil), i18n("common_text_204"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					djCtrl:sendDJOpen()
					self:closePanel()
				end
			end)
		else
			self:closePanel()
		end
	end
end
function DjView:onExitPanel()
	print("chatView: on Exit Panel")
	chatDataMgr:cleanDJNodeData()
end
return DjView
