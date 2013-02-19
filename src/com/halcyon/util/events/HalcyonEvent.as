package com.halcyon.util.events
{
	import flash.events.Event;

	/**
	 * An extension of the flash Event class that lets us send some extra data with the event.
	 */
	public class HalcyonEvent extends Event {

		/**
		 * Extra data that will be included when this event is dispatched.
		 */
		private var extra:Object;


		/**
		 * @inheritDoc
		 *
		 * @param extra Extra data that will be included when this event is dispatched
		 */
		public function HalcyonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, extra:Object = null) {
			super(type, bubbles, cancelable);
			this.extra = extra;
		}

		/**
		 * Sets the extra data that will be sent with the event.
		 * @param extra An object to be sent with the event
		 */
		public function setExtra(extra:Object) : void {
			this.extra = extra;
		}

		/**
		 * Retrieves the extra data sent with event.
		 * @returns An object with any number of properties
		 */
		public function getExtra() : Object{
			return this.extra;
		}

		/**
		 * @inheritDoc
		 */
        public override function clone(): Event {
			return new HalcyonEvent(type, bubbles, cancelable, extra);
		}
	}
}