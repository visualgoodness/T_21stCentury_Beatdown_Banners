package com.visualgoodness.controller
{	
	import com.visualgoodness.events.VGAppEvent;
	import com.visualgoodness.events.VGNotificationCenter;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * The VGController class has a two important functions.  First, when subclassesed in an an application,
	 * it seves a mediator for view components to comminicate with the rest of the application.  VGController
	 * subclasses are best suited to mediate a related group of views or a single complex view that otherwise
	 * would be more suited to be subclasses of VGBasicView (see VGBasicView documentation).  Second,
	 * VGVController is a base class of a model, proxy, timer or any other non-visual component that needs
	 * to commuicate with other parts of the application.  The common functionality in these two uses is
	 * accomplished through the use of the <code>sendNotification</code> and <code>receiveNotification</code>
	 * methods.  
	 * 
	 * @author Patrick Lynch
	 */
	public class VGController extends EventDispatcher
	{
		private var _notificationCenter:VGNotificationCenter;
			
		public function VGController()
		{
			_notificationCenter = VGNotificationCenter.GetInstance();
			connectToApplication();
		}
		
		/**
		 * A reference to the model property that has previously been assigned on VGNotificationCenter.  This
		 * is useful for applications that have a single model or one primary model that needs to be accessed
		 * most commonly by subclasses of VGController or VGBasicView.
		 */
		protected function get model():VGController
		{
			return _notificationCenter.model;
		}
		
		protected function get keyboardController():VGKeyboard
		{
			return _notificationCenter.keyboardController;
		}
		
		
		/**
		 * Adds the event listeners for application-wide notifications used by the <code>sendNotification</code>
		 * and <code>receiveNotification</code> methods.  These listeners are activate by default, so this method
		 * is most useful for connecting an already disconnected component.
		 */
		public function connectToApplication():void
		{
			_notificationCenter.addEventListener(VGAppEvent.UPDATE, update);
		}
		
		
		/**
		 * Removes the event listeners for application-wide notifications used by the <code>sendNotification</code>
		 * and <code>receiveNotification</code> methods.  These listeners are activate by default, so this method
		 * is most useful for temporarily or permanent disabling an application component.
		 */
		public function disconnectedFromApplication():void
		{
			_notificationCenter.removeEventListener(VGAppEvent.UPDATE, update);
		}
		
		/**
		 * Designed to be overriden by subclasses wherein event listeners should be removed and other large objects
		 * in memory set to null.  Remember to call <code>super.kill()</code>, which will also remove event
		 * listeners for applicaiton-wide notifications.
		 * 
		 * @see disconnectFromApplication
		 */
		public function kill():void
		{
			disconnectedFromApplication();
		}
		
		/**
		 * This method is called when an application-wide event is handled, and is the main method for receiving
		 * notifications through application's Singleton instance of VGNotificationCenter.  All components that
		 * subclass VGController or VGBasicView should override this method and use a <code>switch</code>
		 * statementon the <code>notification</code> paramters to write behaviors for specific notifications. 
		 * 
		 * @param notification A unique identifier that tags the dispatched event so that events coming in can be differentiated.
		 * @param data An optional <code>Object</code> to which data has been attached from where the notification was sent.
		 */
		protected function receiveNotification(notification:String, data:Object):void {}
		
		/**
		 * This method dispatches an event on an application's Singleton instance of VGNotificationCenter.  All other
		 * components that subclass VGController or VGBasicView view are listening for this event so long as they are
		 * connected to the application.  These communications between components are known in this framework as <i>Notifications</i>.
		 * 
		 * @param notification A unique identifier that tags the dispatched event so that components listening for
		 * application-wide updates can differentiate between the events coming in through <code>receiveNotification</code>.
		 * @param data An optional <code>Object</code> to which data can be attached and read where the notification
		 * is being received.  It is recommended that you use a structure similar to the following:
		 * <p><code>sendNotification(MyNotificationClass.MY_STRING_CONSTANT, { myParam1:"stringParam", myParam2:3 });</code></p>
		 */
		protected function sendNotification(notification:String, data:Object = null):void
		{
			_notificationCenter.dispatchEvent(new VGAppEvent(VGAppEvent.UPDATE, notification, data));
		}
		
		private function update(e:VGAppEvent):void
		{
			receiveNotification(e.notification, e.data);
		}
	}
}