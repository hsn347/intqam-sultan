local publicRead = include("publicRead")
local sinbadTreasureRead = include("sinbadTreasureRead")
local h5ActivityCtrl = SoraDGetCtrl("h5ActivityCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local communityCenterNewView = class("communityCenterNewView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("communityCenterNewView")
	end
	return target
end)
local singleRankW = 185
function _ENV(target)
	if target == nil then
		return SoraDCreateBasePanel("communityCenterNewView")
	end
	return target
end
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("communityCenterNewView")
	end
	return target
end).NONE = 0
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("communityCenterNewView")
	end
	return target
end).REDPOINT = 1
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("communityCenterNewView")
	end
	return target
end).EXCLAMATION = 2
markType, (function(target)
	if target == nil then
		return SoraDCreateBasePanel("communityCenterNewView")
	end
	return target
end).GIFT = function(target)
	if target == nil then
		return SoraDCreateBasePanel("communityCenterNewView")
	end
	return target
end, 3
function communityCenterNewView:ctor()
	self:initControls()
	self:fitDevice()
end
function communityCenterNewView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_H5ACTIVITY_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		self.ccs_tab:setContentSize(cc.size(640, 55))
		self.ccs_tab:setNewStyle()
		_ENV = cc.size(640, 55)
		cc.size(640, 55).tabNum = 2
		_ENV, _ENV, cc.size(640, 55).defaultClick = cc.size(640, 55)
		cc.size(640, 55).title = i18n("common_text_3421")
		_ENV, cc.size(640, 55)[1], cc.size(640, 55).handle = cc.size(640, 55)
		cc.size(640, 55).title = i18n("Community_name_01")
		cc.size(640, 55).tabsetArray, cc.size(640, 55)[2], cc.size(640, 55).handle = cc.size(640, 55)
		self.ccs_tab:initView(cc.size(640, 55))
	end)
	SoraDAddMessage(self, "MESSAGE_H5ACTIVITY_NEW_CLEAR_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_H5ACTIVITY_MARK_CLEAR_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function communityCenterNewView:fitDevice()
	print("slkdjflsjfldskfj", display.height)
	if math.floor(display.height) == 853 then
		self.Node_main:setScale(0.6)
		self.Node_facebook:setScale(0.6)
		self.Node_main:setPositionY(650)
		self.Node_facebook:setPositionY(650)
		self.frame_sq_ttbg_11:setPositionY(self.Node_facebook:getPositionY() - 185)
	elseif display.height == 960 then
		self.Node_main:setScale(0.8)
		self.Node_facebook:setScale(0.8)
		self.Node_main:setPositionY(590)
		self.Node_facebook:setPositionY(590)
	else
		self.frame_sq_ttbg_11:setPositionY(self.Node_facebook:getPositionY() - 300)
	end
	if math.floor(display.height) >= 1200 then
		self.Node_change:setPositionY(self.Node_change:getPositionY() + 150)
	end
end
function communityCenterNewView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_event")
	self.ccs_title:setTitle(i18n("activity_name_9001200"))
	self.activityID = gActivityTimeActivityID.COMMUNITY_CENTER
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtnEX_tab")
	self.btn_go:setTitleText(i18n("Community_text_0001"))
	self.Text_btn_fb:setString(i18n("Community_text_0001"))
	self.Text_btn_tw:setString(i18n("Community_name_03"))
	self.Text_btn_ins:setString(i18n("Community_name_02"))
	self.btnHelpTip:setVisible(false)
	self.Node_main:setVisible(true)
	self.Node_facebook:setVisible(false)
	SoraDSetTextWidthHeight(self.Text_btn_fb, cc.size(100, 60))
	self.Text_btn_fb:setPositionX(self.Text_btn_fb:getPositionX() + 30)
	self.btn_go:addTouchEventListener(handler(self, self.btnFindClick))
	self.Button_yure:addTouchEventListener(handler(self, self.btnYureClick))
	self.Button_activity:addTouchEventListener(handler(self, self.btnActivityClick))
	self.Button_official:addTouchEventListener(handler(self, self.btnOfficialClick))
	self.Button_video:addTouchEventListener(handler(self, self.btnVideoClick))
	self.btn_FaceBook:addTouchEventListener(handler(self, self.btnFaceBookClick))
	self.btn_instagram:addTouchEventListener(handler(self, self.btnInstagramClick))
	self.btn_twitter:addTouchEventListener(handler(self, self.btnTwitterClick))
	self.Button_newContent:addTouchEventListener(handler(self, self.btnNewContentClick))
	self.Button_hdyj:addTouchEventListener(handler(self, self.btnHdyjlClick))
	self.Button_match:addTouchEventListener(handler(self, self.btnMatchClick))
	self.Text_yure:setString(i18n("Community_text_0002"))
	self.Text_hdzx:setString(i18n("Community_text_0003"))
	self.Text_official:setString(i18n("Community_text_0005"))
	self.Text_video:setString(i18n("Community_text_0004"))
	self.Text_newContent:setString(i18n("Community_text_0002"))
	self.Text_hdyj:setString(i18n("Community_text_0007"))
	self.Text_match:setString(i18n("Community_text_0011"))
	self.Node_one:setPositionY(210)
	self.ScrollView_1:setPositionY(190)
	self.icon_fb:setVisible(false)
	self.icon_ins:setVisible(false)
	self.icon_tw_23:setVisible(false)
	self.btn_FaceBook:setVisible(false)
	self.btn_instagram:setVisible(false)
	self.btn_twitter:setVisible(false)
	self.Button_match:setEnabled(false)
	h5ActivityCtrl:reqInit()
	SoraDShowLoading(self)
end
function communityCenterNewView:initData()
	local communityCenterData = h5ActivityCtrl:getCommunityCenterData()
	if next(communityCenterData) then
		if next(communityCenterData.fbMatch) then
			self.Button_match:setEnabled(true)
			if communityCenterData.fbMatch.title ~= "" then
				self.Text_match:setString(communityCenterData.fbMatch.title)
			end
			SoraDGetPictureFromManager(self.bg_sq_gfzbhf_44, communityCenterData.fbMatch.pic_url)
		end
		if next(communityCenterData.fbNewVersion) then
			self.Button_newContent:setEnabled(true)
			if communityCenterData.fbNewVersion.title ~= "" then
				self.Text_newContent:setString(communityCenterData.fbNewVersion.title)
			end
			SoraDGetPictureFromManager(self.bg_sq_bbyr_35, communityCenterData.fbNewVersion.pic_url)
		end
		if next(communityCenterData.fbInteractionReward) then
			self.Button_hdyj:setEnabled(true)
			if communityCenterData.fbInteractionReward.title ~= "" then
				self.Text_hdyj:setString(communityCenterData.fbInteractionReward.title)
			end
			SoraDGetPictureFromManager(self.frame_sq_hdzx_42, communityCenterData.fbInteractionReward.pic_url)
		end
		local oneList, sortList = self:getRightTypeList(communityCenterData.info)
		self:initScroll(oneList, sortList)
	end
	self.communityCenterData = communityCenterData
end
function communityCenterNewView:getRightTypeList(mainList)
	dump(mainList, "sdjflskdjkflsdfj1111")
	local _ENV, topOneList = dump, dump
	local _ENV, typeList = mainList, mainList
	for i, v in ipairs(mainList) do
		if tonumber(v.type) == self.chooseType then
			if v.main_show == 1 then
				table.insert(topOneList, v)
			else
				table.insert(typeList, v)
			end
		end
	end
	table.sort(typeList, function(a, b)
		return a.order > b.order
	end)
	return topOneList, typeList
end
function communityCenterNewView:initScroll(oneList, postList)
	if oneList and next(oneList) then
		self.Node_one:removeAllChildren()
		local cellOne = self.Node_single:clone()
		cellOne:setPosition(0, -20)
		cellOne:addTo(self.Node_one)
		local Text_tiezi = SoraDGetChildByName(cellOne, "Text_tiezi")
		local Button_single = SoraDGetChildByName(cellOne, "Button_single")
		local icon_single_new = SoraDGetChildByName(cellOne, "icon_single_new")
		local icon_single_mark = SoraDGetChildByName(cellOne, "icon_single_mark")
		local Image_icon = SoraDGetChildByName(cellOne, "Image_icon")
		Button_single:setSwallowTouches(false)
		Text_tiezi:setString(oneList[1].title)
		icon_single_new:setVisible(oneList[1].newFlag)
		icon_single_mark:setVisible(oneList[1].markFlag)
		Button_single:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				userSDKManager.openSDKLink(oneList[1].jump_url)
				if oneList[1].newFlag then
					h5ActivityCtrl:reqClearNew(oneList[1].index)
				end
				if oneList[1].markFlag then
					h5ActivityCtrl:reqClearMark(oneList[1].index)
				end
			end
		end)
		if oneList[1].mark_type == markType.REDPOINT then
			icon_single_mark:setSpriteFrame("frame_hongdian.png")
		elseif oneList[1].mark_type == markType.EXCLAMATION then
			icon_single_mark:setSpriteFrame("frame_tanhao.png")
		elseif oneList[1].mark_type == markType.GIFT then
			icon_single_mark:setSpriteFrame("icon_mail_adjunct.png")
			icon_single_mark:setScale(0.6)
		end
		SoraDGetPictureFromManager(Image_icon, oneList[1].pic_url)
	end
	if postList and next(postList) then
		self.ScrollView_1:removeAllChildren()
		local scrollW = math.max(self.ScrollView_1:getContentSize().width, singleRankW * #postList)
		self.ScrollView_1:setInnerContainerSize(cc.size(scrollW, 160))
		for i, v in ipairs(postList) do
			local cellRank = self.Node_single:clone()
			cellRank:setPosition(95 + (i - 1) * singleRankW, self.ScrollView_1:getContentSize().height / 2)
			if SoraDFIsRA() then
				cellRank:setPosition(scrollW - 95 - (i - 1) * singleRankW, self.ScrollView_1:getContentSize().height / 2)
			end
			cellRank:addTo(self.ScrollView_1)
			local Text_tiezi = SoraDGetChildByName(cellRank, "Text_tiezi")
			local Button_single = SoraDGetChildByName(cellRank, "Button_single")
			local icon_single_new = SoraDGetChildByName(cellRank, "icon_single_new")
			local icon_single_mark = SoraDGetChildByName(cellRank, "icon_single_mark")
			local Image_icon = SoraDGetChildByName(cellRank, "Image_icon")
			Button_single:setSwallowTouches(false)
			Text_tiezi:setString(v.title)
			icon_single_new:setVisible(v.newFlag)
			icon_single_mark:setVisible(v.markFlag)
			Button_single:addTouchEventListener(function(ref, type)
				if type == ccui.TouchEventType.ended then
					SoraDPlaySound()
					if self.isMoved then
						self.isMoved = false
						return
					end
					if self.ScrollView_1 and not SoraDIsNodeVisibleOnScroll(ref, self.ScrollView_1) then
						print("node is not on view")
						return
					end
					userSDKManager.openSDKLink(v.jump_url)
					if v.newFlag then
						h5ActivityCtrl:reqClearNew(v.index)
					end
					if v.markFlag then
						h5ActivityCtrl:reqClearMark(v.index)
					end
				elseif type == ccui.TouchEventType.moved then
					local touchBeganPoint = Button_single:getTouchBeganPosition()
					local touchmovePoint = Button_single:getTouchMovePosition()
					local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
					if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
						self.isMoved = true
					end
				elseif type == ccui.TouchEventType.canceled then
					self.isMoved = false
				end
			end)
			if v.mark_type == markType.REDPOINT then
				icon_single_mark:setSpriteFrame("frame_hongdian.png")
			elseif v.mark_type == markType.EXCLAMATION then
				icon_single_mark:setSpriteFrame("frame_tanhao.png")
			elseif v.mark_type == markType.GIFT then
				icon_single_mark:setSpriteFrame("icon_mail_adjunct.png")
				icon_single_mark:setScale(0.6)
			end
			SoraDGetPictureFromManager(Image_icon, v.pic_url)
		end
		if SoraDFIsRA() then
			self.ScrollView_1:jumpToRight()
		end
	end
end
function communityCenterNewView:onCommunityClick(tag, name)
	self.Node_main:setVisible(true)
	self.Node_facebook:setVisible(false)
	self.btn_FaceBook:setVisible(false)
	self.btn_instagram:setVisible(false)
	self.btn_twitter:setVisible(false)
	self.btn_go:setVisible(true)
	self.Text_sq_title:setString(i18n("Community_text_0008"))
	self.chooseType = 1
	self:initData()
end
function communityCenterNewView:onFacebookClick(tag, name)
	if not IsArClient then
		SoraDShowMsgTip(i18n("common_text_413"))
		self.ccs_tab:clickByTag(1)
		return
	end
	self.Node_main:setVisible(false)
	self.Node_facebook:setVisible(true)
	self.btn_FaceBook:setVisible(true)
	self.btn_instagram:setVisible(true)
	self.btn_twitter:setVisible(true)
	self.btn_go:setVisible(false)
	self.Text_sq_title:setString(i18n("Community_text_0009"))
	self.chooseType = 2
	self:initData()
end
function communityCenterNewView:btnMatchClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("赛事抢先看")
		local communityCenterData = h5ActivityCtrl:getCommunityCenterData()
		userSDKManager.openSDKLink(communityCenterData.fbMatch.jump_url)
	end
end
function communityCenterNewView:btnNewContentClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("新版本内容")
		if IsArClient then
			userSDKManager.openSDKLink("https://bit.ly/Ljxbbnr")
		else
			userSDKManager.openSDKLink("https://forum.onemtshare.com/a/6791688?game=100000611")
		end
	end
end
function communityCenterNewView:btnHdyjlClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("互动赢奖励")
		if self.communityCenterData.fbInteractionReward and self.communityCenterData.fbInteractionReward.jump_url ~= "" then
			print("互动赢奖励有设置链接")
			userSDKManager.openSDKLink(self.communityCenterData.fbInteractionReward.jump_url)
		else
			userSDKManager.openSDKLink("https://bit.ly/Cyhdyjl")
		end
	end
end
function communityCenterNewView:btnFindClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("社区入口")
		userSDKManager.showSocial()
	end
end
function communityCenterNewView:btnFaceBookClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("Facebook入口")
		userSDKManager.openSDKLink("https://www.facebook.com/slateen/")
	end
end
function communityCenterNewView:btnInstagramClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("Instagram入口")
		userSDKManager.openSDKLink("https://www.instagram.com/revengeofsultans/")
	end
end
function communityCenterNewView:btnTwitterClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("Twitter入口")
		userSDKManager.openSDKLink("https://twitter.com/EntkamElSlaten")
	end
end
function communityCenterNewView:btnYureClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("版本预热")
		userSDKManager.openSDKLink("https://apicosdk.onemt.co?action=category&categoryId=1")
	end
end
function communityCenterNewView:btnActivityClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("活动中心")
		if IsArClient then
			userSDKManager.openSDKLink("https://apicosdk.onemt.co?action=category&categoryId=2")
		else
			userSDKManager.openSDKLink("https://forum.onemtshare.com/a/6797358?game=100000611")
		end
	end
end
function communityCenterNewView:btnOfficialClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("官方直播/回复")
		if IsArClient then
			userSDKManager.openSDKLink("https://apicosdk.onemt.co?action=category&categoryId=68")
		else
			userSDKManager.openSDKLink("https://forum.onemtshare.com/a/6794029?game=100000611")
		end
	end
end
function communityCenterNewView:btnVideoClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("视频讲解")
		if IsArClient then
			userSDKManager.openSDKLink("https://apicosdk.onemt.co?action=category&categoryId=43")
		else
			userSDKManager.openSDKLink("https://forum.onemtshare.com/a/6764573?game=100000611")
		end
	end
end
function communityCenterNewView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return communityCenterNewView
