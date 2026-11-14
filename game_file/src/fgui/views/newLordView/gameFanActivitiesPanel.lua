local baseFguiPanel = require("fgui.base.baseFguiPanel")
local gameFanActivitiesPanel = class("gameFanActivitiesPanel", baseFguiPanel)
function gameFanActivitiesPanel:ctor(...)
	self.super.ctor(self, ...)
	print("gameFanActivitiesPanel:ctor", self.viewName)
end
function gameFanActivitiesPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function gameFanActivitiesPanel:onInit()
	print("=======gameFanActivitiesPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_719"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function gameFanActivitiesPanel:onShow()
	print("=======gameFanActivitiesPanel:onShow")
	self.TmpData, _ENV = print, print
	local channel = userSDKManager.getChannel()
	if "fa" == channel then
		_ENV, _UPVALUE2_ = nil, "=======gameFanActivitiesPanel:onShow"
		;(nil).linkID = 1
		;(nil).popTitle = "Telegram"
		;(nil).linkTitle = "Telegram"
		;(nil).linkIcon = "icon_telegram.png"
		_ENV, (nil).openFun = nil, "https://t.me/Magnetgame_ROS"
		;(nil).linkID = 2
		;(nil).popTitle = "Instagram"
		;(nil).linkTitle = "Instagram"
		;(nil).linkIcon = "icon_instagram.png"
		;(nil).openFun = "https://www.instagram.com/magnetgame"
		self.TmpData, ("=======gameFanActivitiesPanel:onShow")[1] = "=======gameFanActivitiesPanel:onShow"
		self.TmpData, ("=======gameFanActivitiesPanel:onShow")[2] = "=======gameFanActivitiesPanel:onShow"
	else
		local facebookOpenFun = function(...)
			if IsArClient then
				userSDKManager.openWithFacebook("fb://page/1014434145243320", "https://fb.me/slateen")
			elseif userSDKManager.isKO() then
				userSDKManager.openWithFacebook("fb://page/409758043167737", "https://fb.me/RevengeOfSultansKR")
			else
				userSDKManager.openWithFacebook("fb://page/945786632178612", "https://fb.me/revengeofsultans")
			end
		end
		_ENV, _UPVALUE1_ = nil, nil
		;(nil).linkID = 1
		;(nil).popTitle = "Facebook"
		;(nil).linkTitle = i18n("common_text_966")
		;(nil).linkIcon = "icon_facebook.png"
		;(nil).openFun = facebookOpenFun
		self.TmpData, (nil)[1] = nil, nil
	end
	self.fields.List:setNumItems(#self.TmpData)
end
function gameFanActivitiesPanel:onItemRederer(index, target)
	target:initData(self.TmpData[index + 1])
end
return gameFanActivitiesPanel
