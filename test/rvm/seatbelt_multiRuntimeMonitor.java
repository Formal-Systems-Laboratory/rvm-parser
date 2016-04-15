
import java.util.concurrent.*;
import java.util.concurrent.locks.*;
import java.util.*;
import java.lang.ref.*;
import com.runtimeverification.rvmonitor.java.rt.*;
import com.runtimeverification.rvmonitor.java.rt.ref.*;
import com.runtimeverification.rvmonitor.java.rt.table.*;
import com.runtimeverification.rvmonitor.java.rt.tablebase.AbstractIndexingTree;
import com.runtimeverification.rvmonitor.java.rt.tablebase.SetEventDelegator;
import com.runtimeverification.rvmonitor.java.rt.tablebase.TableAdopter.Tuple2;
import com.runtimeverification.rvmonitor.java.rt.tablebase.TableAdopter.Tuple3;
import com.runtimeverification.rvmonitor.java.rt.tablebase.IDisableHolder;
import com.runtimeverification.rvmonitor.java.rt.tablebase.IMonitor;
import com.runtimeverification.rvmonitor.java.rt.tablebase.DisableHolder;
import com.runtimeverification.rvmonitor.java.rt.tablebase.TerminatedMonitorCleaner;
import java.util.concurrent.atomic.AtomicInteger;

final class SeatBeltMonitor_Set extends com.runtimeverification.rvmonitor.java.rt.tablebase.AbstractMonitorSet<SeatBeltMonitor> {

	SeatBeltMonitor_Set(){
		this.size = 0;
		this.elements = new SeatBeltMonitor[4];
	}
	final void event_seatBeltRemoved() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SeatBeltMonitor monitor = this.elements[i];
			if(!monitor.isTerminated()){
				elements[numAlive] = monitor;
				numAlive++;

				final SeatBeltMonitor monitorfinalMonitor = monitor;
				monitor.Prop_1_event_seatBeltRemoved();
				if(monitorfinalMonitor.Prop_1_Category_safe) {
					monitorfinalMonitor.Prop_1_handler_safe();
				}
				if(monitorfinalMonitor.Prop_1_Category_unsafe) {
					monitorfinalMonitor.Prop_1_handler_unsafe();
				}
				final SeatBeltMonitor monitorfinalMonitor = monitor;
				monitor.Prop_2_event_seatBeltRemoved();
				if(monitorfinalMonitor.Prop_2_Category_safe2) {
					monitorfinalMonitor.Prop_2_handler_safe2();
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elements[i] = null;
		}
		size = numAlive;
	}
	final void event_seatBeltAttached() {
		int numAlive = 0 ;
		for(int i = 0; i < this.size; i++){
			SeatBeltMonitor monitor = this.elements[i];
			if(!monitor.isTerminated()){
				elements[numAlive] = monitor;
				numAlive++;

				final SeatBeltMonitor monitorfinalMonitor = monitor;
				monitor.Prop_1_event_seatBeltAttached();
				if(monitorfinalMonitor.Prop_1_Category_safe) {
					monitorfinalMonitor.Prop_1_handler_safe();
				}
				if(monitorfinalMonitor.Prop_1_Category_unsafe) {
					monitorfinalMonitor.Prop_1_handler_unsafe();
				}
				final SeatBeltMonitor monitorfinalMonitor = monitor;
				monitor.Prop_2_event_seatBeltAttached();
				if(monitorfinalMonitor.Prop_2_Category_safe2) {
					monitorfinalMonitor.Prop_2_handler_safe2();
				}
			}
		}
		for(int i = numAlive; i < this.size; i++){
			this.elements[i] = null;
		}
		size = numAlive;
	}
}

class SeatBeltMonitor extends com.runtimeverification.rvmonitor.java.rt.tablebase.AbstractAtomicMonitor implements Cloneable, com.runtimeverification.rvmonitor.java.rt.RVMObject {
	protected Object clone() {
		try {
			SeatBeltMonitor ret = (SeatBeltMonitor) super.clone();
			ret.pairValue = new AtomicInteger(pairValue.get());
			return ret;
		}
		catch (CloneNotSupportedException e) {
			throw new InternalError(e.toString());
		}
	}

	static final int Prop_1_transition_seatBeltRemoved[] = {2, 0, 2};;
	static final int Prop_1_transition_seatBeltAttached[] = {1, 2, 2};;

	static final int Prop_2_transition_seatBeltRemoved[] = {2, 0, 2};;
	static final int Prop_2_transition_seatBeltAttached[] = {1, 2, 2};;

	volatile boolean Prop_1_Category_safe = false;
	volatile boolean Prop_1_Category_unsafe = false;
	volatile boolean Prop_2_Category_safe2 = false;

	private AtomicInteger pairValue;

	SeatBeltMonitor() {
		this.pairValue = new AtomicInteger(this.calculatePairValue(-1, 0) ) ;

		this.pairValue = new AtomicInteger(this.calculatePairValue(-1, 0) ) ;

	}

	@Override public final int getState() {
		return this.getState(this.pairValue.get() ) ;
	}
	@Override public final int getLastEvent() {
		return this.getLastEvent(this.pairValue.get() ) ;
	}
	private final int getState(int pairValue) {
		return (pairValue & 0) ;
	}
	private final int getLastEvent(int pairValue) {
		return (pairValue >> 0) ;
	}
	private final int calculatePairValue(int lastEvent, int state) {
		return (((lastEvent + 1) << 0) | state) ;
	}

	private final int handleEvent(int eventId, int[] table) {
		int nextstate;
		while (true) {
			int oldpairvalue = this.pairValue.get() ;
			int oldstate = this.getState(oldpairvalue) ;
			nextstate = table [ oldstate ];
			int nextpairvalue = this.calculatePairValue(eventId, nextstate) ;
			if (this.pairValue.compareAndSet(oldpairvalue, nextpairvalue) ) {
				break;
			}
		}
		return nextstate;
	}

	final boolean Prop_1_event_seatBeltRemoved() {

		int nextstate = this.handleEvent(0, Prop_1_transition_seatBeltRemoved) ;
		this.Prop_1_Category_safe = nextstate == 1;
		this.Prop_1_Category_unsafe = nextstate == 0;

		return true;
	}

	final boolean Prop_1_event_seatBeltAttached() {

		int nextstate = this.handleEvent(1, Prop_1_transition_seatBeltAttached) ;
		this.Prop_1_Category_safe = nextstate == 1;
		this.Prop_1_Category_unsafe = nextstate == 0;

		return true;
	}

	final boolean Prop_2_event_seatBeltRemoved() {
		{fprintf(stderr, "Seat belt removed.\n");}

		int nextstate = this.handleEvent(0, Prop_2_transition_seatBeltRemoved) ;
		this.Prop_2_Category_safe2 = nextstate == 1;

		return true;
	}

	final boolean Prop_2_event_seatBeltAttached() {
		{fprintf(stderr, "Seat belt attached.\n");}

		int nextstate = this.handleEvent(1, Prop_2_transition_seatBeltAttached) ;
		this.Prop_2_Category_safe2 = nextstate == 1;

		return true;
	}

	final void Prop_1_handler_safe (){
		{
			fprintf(stderr, "set max speed to user input.\n");
		}

	}

	final void Prop_1_handler_unsafe (){
		{
			fprintf(stderr, "set max speed to 10 mph.\n");
		}

	}

	final void Prop_2_handler_safe2 (){
		{
			fprintf(stderr, "It's safe.\n");
		}

	}

	final void reset() {
		this.pairValue.set(this.calculatePairValue(-1, 0) ) ;

		Prop_1_Category_safe = false;
		Prop_1_Category_unsafe = false;
		this.pairValue.set(this.calculatePairValue(-1, 0) ) ;

		Prop_2_Category_safe2 = false;
	}

	@Override
	protected final void terminateInternal(int idnum) {
		int lastEvent = this.getLastEvent();

		switch(idnum){
		}
		switch(lastEvent) {
			case -1:
			return;
			case 0:
			//seatBeltRemoved
			return;
			case 1:
			//seatBeltAttached
			return;
		}
		return;
	}

	public static int getNumberOfEvents() {
		return 2;
	}

	public static int getNumberOfStates() {
		return -1;
	}

}

public final class seatbelt_multiRuntimeMonitor implements com.runtimeverification.rvmonitor.java.rt.RVMObject {
	private static com.runtimeverification.rvmonitor.java.rt.map.RVMMapManager seatbelt_multiMapManager;
	static {
		seatbelt_multiMapManager = new com.runtimeverification.rvmonitor.java.rt.map.RVMMapManager();
		seatbelt_multiMapManager.start();
	}

	// Declarations for the Lock
	static final ReentrantLock seatbelt_multi_RVMLock = new ReentrantLock();
	static final Condition seatbelt_multi_RVMLock_cond = seatbelt_multi_RVMLock.newCondition();

	private static boolean SeatBelt_activated = false;

	// Declarations for Indexing Trees
	private static final SeatBeltMonitor SeatBelt__Map = new SeatBeltMonitor() ;

	public static int cleanUp() {
		int collected = 0;
		// indexing trees
		return collected;
	}

	// Removing terminated monitors from partitioned sets
	static {
		TerminatedMonitorCleaner.start() ;
	}
	// Setting the behavior of the runtime library according to the compile-time option
	static {
		RuntimeOption.enableFineGrainedLock(false) ;
	}

	public static final void seatBeltRemovedEvent() {
		SeatBelt_activated = true;
		while (!seatbelt_multi_RVMLock.tryLock()) {
			Thread.yield();
		}

		SeatBeltMonitor matchedEntry = null;
		{
			// FindOrCreateEntry
			matchedEntry = SeatBelt__Map;
		}
		// D(X) main:1
		if ((matchedEntry == null) ) {
			// D(X) main:4
			SeatBeltMonitor created = new SeatBeltMonitor() ;
			matchedEntry = created;
		}
		// D(X) main:8--9
		final SeatBeltMonitor matchedEntryfinalMonitor = matchedEntry;
		matchedEntry.Prop_1_event_seatBeltRemoved();
		if(matchedEntryfinalMonitor.Prop_1_Category_safe) {
			matchedEntryfinalMonitor.Prop_1_handler_safe();
		}
		if(matchedEntryfinalMonitor.Prop_1_Category_unsafe) {
			matchedEntryfinalMonitor.Prop_1_handler_unsafe();
		}
		final SeatBeltMonitor matchedEntryfinalMonitor = matchedEntry;
		matchedEntry.Prop_2_event_seatBeltRemoved();
		if(matchedEntryfinalMonitor.Prop_2_Category_safe2) {
			matchedEntryfinalMonitor.Prop_2_handler_safe2();
		}

		seatbelt_multi_RVMLock.unlock();
	}

	public static final void seatBeltAttachedEvent() {
		SeatBelt_activated = true;
		while (!seatbelt_multi_RVMLock.tryLock()) {
			Thread.yield();
		}

		SeatBeltMonitor matchedEntry = null;
		{
			// FindOrCreateEntry
			matchedEntry = SeatBelt__Map;
		}
		// D(X) main:1
		if ((matchedEntry == null) ) {
			// D(X) main:4
			SeatBeltMonitor created = new SeatBeltMonitor() ;
			matchedEntry = created;
		}
		// D(X) main:8--9
		final SeatBeltMonitor matchedEntryfinalMonitor = matchedEntry;
		matchedEntry.Prop_1_event_seatBeltAttached();
		if(matchedEntryfinalMonitor.Prop_1_Category_safe) {
			matchedEntryfinalMonitor.Prop_1_handler_safe();
		}
		if(matchedEntryfinalMonitor.Prop_1_Category_unsafe) {
			matchedEntryfinalMonitor.Prop_1_handler_unsafe();
		}
		final SeatBeltMonitor matchedEntryfinalMonitor = matchedEntry;
		matchedEntry.Prop_2_event_seatBeltAttached();
		if(matchedEntryfinalMonitor.Prop_2_Category_safe2) {
			matchedEntryfinalMonitor.Prop_2_handler_safe2();
		}

		seatbelt_multi_RVMLock.unlock();
	}

}
