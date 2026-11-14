local link_service = gSvrConfig.linkUrlConfig.service
local link_policy = gSvrConfig.linkUrlConfig.policy
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local gamePolicyAndTermsPanel = class("gamePolicyAndTermsPanel", baseFguiPanel)
function gamePolicyAndTermsPanel:ctor(...)
	self.super.ctor(self, ...)
	print("gamePolicyAndTermsPanel:ctor", self.viewName)
end
function gamePolicyAndTermsPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function gamePolicyAndTermsPanel:onInit()
	print("=======gamePolicyAndTermsPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_2028"), handler(self, self.onClickClose))
	self.fields.Text_superLink:fixPos()
	self.fields.Text_superLink_2:fixPos()
	self.fields.Text_superLink:addClickListener(handler(self, self.btnTermsClickCallBack))
	_ENV = handler(self, self.btnTermsClickCallBack)
	handler(self, self.btnTermsClickCallBack).link = ""
	_ENV = handler(self, self.btnTermsClickCallBack)
	handler(self, self.btnTermsClickCallBack).color = "#d4c495"
	handler(self, self.btnTermsClickCallBack).u = true
	self.fields.Text_superLink:setString(i18n("common_text_4507", handler(self, self.btnTermsClickCallBack)) .. "\n" .. SoraDWrapHtmlTagByStyle(link_service, handler(self, self.btnTermsClickCallBack)))
	self.fields.Text_superLink_2:addClickListener(handler(self, self.btnPolicyClickCallBack))
	_ENV = handler(self, self.btnPolicyClickCallBack)
	handler(self, self.btnPolicyClickCallBack).link = ""
	_ENV = handler(self, self.btnPolicyClickCallBack)
	handler(self, self.btnPolicyClickCallBack).color = "#d4c495"
	handler(self, self.btnPolicyClickCallBack).u = true
	self.fields.Text_superLink_2:setString(i18n("common_text_4508", handler(self, self.btnPolicyClickCallBack)) .. "\n" .. SoraDWrapHtmlTagByStyle(link_policy, handler(self, self.btnPolicyClickCallBack)))
end
function gamePolicyAndTermsPanel:onShow()
	print("=======gamePolicyAndTermsPanel:onShow")
end
function gamePolicyAndTermsPanel:btnTermsClickCallBack()
	SoraDPlaySound()
	print("条款")
	userSDKManager.openSDKLink(link_service)
end
function gamePolicyAndTermsPanel:btnPolicyClickCallBack()
	SoraDPlaySound()
	print("政策")
	userSDKManager.openSDKLink(link_policy)
end
return gamePolicyAndTermsPanel
