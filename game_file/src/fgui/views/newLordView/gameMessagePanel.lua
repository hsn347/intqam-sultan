local baseFguiPanel = require("fgui.base.baseFguiPanel")
local gameMessagePanel = class("gameMessagePanel", baseFguiPanel)
function gameMessagePanel:ctor(...)
	self.super.ctor(self, ...)
	print("gameMessagePanel:ctor", self.viewName)
end
function gameMessagePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function gameMessagePanel:onInit()
	print("=======gameMessagePanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_717"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	_UPVALUE1_, _ENV, _UPVALUE15_ = handler(self, self.onItemRederer)
	self.fields.List.tabName, handler(self, self.onItemRederer)[1] = handler(self, self.onItemRederer)
	self.fields.List.title = i18n("common_text_940")
	self.fields.List.content = i18n("common_text_941")
	_UPVALUE1_, _ENV, self.fields.List.flag = "common_text_941", i18n("common_text_941"), nil
	i18n("common_text_941").tabName, ("common_text_941")[1] = "common_text_941", "alliance"
	i18n("common_text_941").title = i18n("common_text_069")
	i18n("common_text_941").content = i18n("common_text_948")
	_UPVALUE1_, _ENV, i18n("common_text_941").flag = "common_text_948", gNoticeType.ALLIANCE_CHAT, gNoticeType.ALLIANCE_CHAT
	gNoticeType.ALLIANCE_CHAT.tabName, ("common_text_948")[1] = "common_text_948", "allianceMail"
	gNoticeType.ALLIANCE_CHAT.title = i18n("common_text_190")
	gNoticeType.ALLIANCE_CHAT.content = i18n("push_message_1")
	_UPVALUE1_, _ENV, gNoticeType.ALLIANCE_CHAT.flag = "push_message_1", gNoticeType.ALLIANCE_GROUP_MAIL, gNoticeType.ALLIANCE_GROUP_MAIL
	gNoticeType.ALLIANCE_GROUP_MAIL.tabName, ("push_message_1")[1] = "push_message_1", "event"
	gNoticeType.ALLIANCE_GROUP_MAIL.title = i18n("common_text_949")
	gNoticeType.ALLIANCE_GROUP_MAIL.content = i18n("common_text_950")
	_UPVALUE1_, _ENV, gNoticeType.ALLIANCE_GROUP_MAIL.flag = "common_text_950", gNoticeType.ACTIVITY_START, gNoticeType.ACTIVITY_START
	gNoticeType.ACTIVITY_START.tabName, ("common_text_950")[1] = "common_text_950", "mail"
	gNoticeType.ACTIVITY_START.title = i18n("chat_text_69")
	gNoticeType.ACTIVITY_START.content = i18n("chat_text_73")
	_UPVALUE1_, _ENV, gNoticeType.ACTIVITY_START.flag = "chat_text_73", gNoticeType.NEW_PERSONAL_MAIL, gNoticeType.NEW_PERSONAL_MAIL
	gNoticeType.NEW_PERSONAL_MAIL.tabName, ("chat_text_73")[1] = "chat_text_73", "levelTrain"
	gNoticeType.NEW_PERSONAL_MAIL.title = i18n("common_text_956")
	gNoticeType.NEW_PERSONAL_MAIL.content = i18n("common_text_957")
	_UPVALUE1_, _ENV, gNoticeType.NEW_PERSONAL_MAIL.flag = "common_text_957", gNoticeType.LEVELUP_AND_TRAIN, gNoticeType.LEVELUP_AND_TRAIN
	gNoticeType.LEVELUP_AND_TRAIN.tabName, ("common_text_957")[1] = "common_text_957", "fightTroop"
	gNoticeType.LEVELUP_AND_TRAIN.title = i18n("common_text_954")
	gNoticeType.LEVELUP_AND_TRAIN.content = i18n("common_text_955")
	_UPVALUE1_, _ENV, gNoticeType.LEVELUP_AND_TRAIN.flag = "common_text_955", gNoticeType.BATTLE_AND_TROOP, gNoticeType.BATTLE_AND_TROOP
	gNoticeType.BATTLE_AND_TROOP.tabName, ("common_text_955")[1] = "common_text_955", "resource"
	gNoticeType.BATTLE_AND_TROOP.title = i18n("common_text_958")
	gNoticeType.BATTLE_AND_TROOP.content = i18n("common_text_959")
	_UPVALUE1_, _ENV, gNoticeType.BATTLE_AND_TROOP.flag = "common_text_959", gNoticeType.HARVEST, gNoticeType.HARVEST
	gNoticeType.HARVEST.tabName, ("common_text_959")[1] = "common_text_959", "price"
	gNoticeType.HARVEST.title = i18n("common_text_951")
	gNoticeType.HARVEST.content = i18n("common_text_952")
	_UPVALUE1_, _ENV, gNoticeType.HARVEST.flag = "common_text_952", gNoticeType.REWARD, gNoticeType.REWARD
	gNoticeType.REWARD.tabName, ("common_text_952")[1] = "common_text_952", "redBag"
	gNoticeType.REWARD.title = i18n("common_text_1850")
	gNoticeType.REWARD.content = i18n("common_text_1851")
	_UPVALUE1_, _ENV, gNoticeType.REWARD.flag = "common_text_1851", gNoticeType.GOLD_GIFT, gNoticeType.GOLD_GIFT
	gNoticeType.GOLD_GIFT.tabName, ("common_text_1851")[1] = "common_text_1851", "warGuard"
	gNoticeType.GOLD_GIFT.title = i18n("common_text_2030")
	gNoticeType.GOLD_GIFT.content = i18n("common_text_2093")
	_UPVALUE1_, _ENV, gNoticeType.GOLD_GIFT.flag = "common_text_2093", gNoticeType.PROTECTION_END, gNoticeType.PROTECTION_END
	gNoticeType.PROTECTION_END.tabName, ("common_text_2093")[1] = "common_text_2093", "allianceAttacked"
	gNoticeType.PROTECTION_END.title = i18n("common_text_2628")
	gNoticeType.PROTECTION_END.content = i18n("common_text_2629")
	_UPVALUE1_, _ENV, gNoticeType.PROTECTION_END.flag = "common_text_2629", gNoticeType.ALLIANCE_ATTACKED, gNoticeType.ALLIANCE_ATTACKED
	gNoticeType.ALLIANCE_ATTACKED.tabName, ("common_text_2629")[1] = "common_text_2629", "tradeBoard"
	gNoticeType.ALLIANCE_ATTACKED.title = i18n("common_text_3359")
	gNoticeType.ALLIANCE_ATTACKED.content = i18n("common_text_3360")
	_UPVALUE1_, _ENV, gNoticeType.ALLIANCE_ATTACKED.flag = "common_text_3360", gNoticeType.SALES_ROOM, gNoticeType.SALES_ROOM
	gNoticeType.SALES_ROOM.tabName, ("common_text_3360")[1] = "common_text_3360", "prisonerExcute"
	gNoticeType.SALES_ROOM.title = i18n("hero_text_96")
	gNoticeType.SALES_ROOM.content = i18n("hero_text_97")
	_UPVALUE1_, _ENV, gNoticeType.SALES_ROOM.flag = "hero_text_97", i18n("hero_text_97"), nil
	i18n("hero_text_97").tabName, ("hero_text_97")[1] = "hero_text_97", "heroTrainFinish"
	i18n("hero_text_97").title = i18n("herotrain_text_25")
	i18n("hero_text_97").content = i18n("herotrain_text_26")
	i18n("hero_text_97").flag = nil
	self.localMsgTable, self.fields.List.setItemRenderer[1] = self.fields.List.setItemRenderer, self.fields.List
	self.localMsgTable, self.fields.List.setItemRenderer[2] = self.fields.List.setItemRenderer, i18n("common_text_941")
	self.localMsgTable, self.fields.List.setItemRenderer[3] = self.fields.List.setItemRenderer, gNoticeType.ALLIANCE_CHAT
	self.localMsgTable, self.fields.List.setItemRenderer[4] = self.fields.List.setItemRenderer, gNoticeType.ALLIANCE_GROUP_MAIL
	self.localMsgTable, self.fields.List.setItemRenderer[5] = self.fields.List.setItemRenderer, gNoticeType.ACTIVITY_START
	self.localMsgTable, self.fields.List.setItemRenderer[6] = self.fields.List.setItemRenderer, gNoticeType.NEW_PERSONAL_MAIL
	self.localMsgTable, self.fields.List.setItemRenderer[7] = self.fields.List.setItemRenderer, gNoticeType.LEVELUP_AND_TRAIN
	self.localMsgTable, self.fields.List.setItemRenderer[8] = self.fields.List.setItemRenderer, gNoticeType.BATTLE_AND_TROOP
	self.localMsgTable, self.fields.List.setItemRenderer[9] = self.fields.List.setItemRenderer, gNoticeType.HARVEST
	self.localMsgTable, self.fields.List.setItemRenderer[10] = self.fields.List.setItemRenderer, gNoticeType.REWARD
	self.localMsgTable, self.fields.List.setItemRenderer[11] = self.fields.List.setItemRenderer, gNoticeType.GOLD_GIFT
	self.localMsgTable, self.fields.List.setItemRenderer[12] = self.fields.List.setItemRenderer, gNoticeType.PROTECTION_END
	self.localMsgTable, self.fields.List.setItemRenderer[13] = self.fields.List.setItemRenderer, gNoticeType.ALLIANCE_ATTACKED
	self.localMsgTable, self.fields.List.setItemRenderer[14] = self.fields.List.setItemRenderer, gNoticeType.SALES_ROOM
	self.localMsgTable, self.fields.List.setItemRenderer[15] = self.fields.List.setItemRenderer, i18n("hero_text_97")
	if _G.IsArClient then
		_UPVALUE1_, _ENV = gNoticeType.ALLIANCE_GROUP_MAIL, gNoticeType.ALLIANCE_CHAT
		gNoticeType.ALLIANCE_CHAT.tabName, gNoticeType.ALLIANCE_GROUP_MAIL[1] = gNoticeType.ALLIANCE_GROUP_MAIL, "radianceWarBuildAttacked"
		gNoticeType.ALLIANCE_CHAT.title = i18n("herotrain_text_29")
		gNoticeType.ALLIANCE_CHAT.content = i18n("herotrain_text_30")
		gNoticeType.ALLIANCE_CHAT.flag = gNoticeType.RADIANCE_BUILD_BE_ATTACKED
		table.insert(self.localMsgTable, 12, gNoticeType.ALLIANCE_CHAT)
	end
	if _G.IsArClient then
		_UPVALUE1_, _ENV = gNoticeType.ALLIANCE_CHAT, 12
		;(12).tabName, gNoticeType.ALLIANCE_CHAT[1] = gNoticeType.ALLIANCE_CHAT, "voiceChatRoom"
		;(12).title = i18n("common_text_4587")
		;(12).content = i18n("common_text_4588")
		;(12).flag = gNoticeType.VOICE_CHAT_INVITATION
		table.insert(self.localMsgTable, 12)
	end
end
function gameMessagePanel:onShow()
	print("=======gameMessagePanel:onShow")
	self.fields.List:setNumItems(#self.localMsgTable)
end
function gameMessagePanel:endShow()
	SoraDCheckPopPushNotification()
end
function gameMessagePanel:onItemRederer(index, target)
	target:initData(self.localMsgTable[index + 1])
end
return gameMessagePanel
