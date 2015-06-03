package edu.sjsu.cmpe239;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.data.mongodb.core.MongoOperations;

import edu.sjsu.cmpe239.config.MongoConfig;
import edu.sjsu.cpme239.model.AssociationRule;
import edu.sjsu.cpme239.model.Beacon;
import edu.sjsu.cpme239.model.Customer;
import edu.sjsu.cpme239.model.Discount;
import edu.sjsu.cpme239.model.History;
import edu.sjsu.cpme239.model.MapReduce;

@RestController
public class RecommendationController {
	MongoUtility mongo= new MongoUtility();
	ApplicationContext ctx = new AnnotationConfigApplicationContext(MongoConfig.class);
	MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");
	
	@RequestMapping(value = "/user/login/{userid}/{password}", method = RequestMethod.GET)
	public ResponseEntity<String> login(@PathVariable("userid") String user_id, @PathVariable("password") String password) {	
		ResponseEntity<String> responseEntity = null;
	Query searchUserQuery = new Query(Criteria.where("username").is(user_id));
	Customer savedUser = mongoOperation.findOne(searchUserQuery, Customer.class);
	if(savedUser != null && savedUser.getPassword().equals(password))
		responseEntity = new ResponseEntity<String>("Success", HttpStatus.OK);	
	else
		responseEntity = new ResponseEntity<String>("Failure", HttpStatus.NOT_FOUND);
	return responseEntity;
	}
	
	@RequestMapping(value = "/user/PersonalizedRecommendation/{userid}/{password}/{majorid}/{minorid}", method = RequestMethod.GET)
	public List<AssociationRule> getRecommendations(@PathVariable("userid") String user_id, @PathVariable("password") String password,@PathVariable("majorid") String major_id,@PathVariable("minorid") String minor_id) {
		Query searchProducts = new Query(Criteria.where("major_id").is(major_id));
		Beacon beacon = mongoOperation.findOne(searchProducts, Beacon.class);
		Set<String> beaconProducts=new HashSet<String>(Arrays.asList(beacon.getProducts()));
		Set<String> beaconProductsNew=new HashSet<String>();
		for(String s:beaconProducts)
		{
			beaconProductsNew.add(clean(s));
		}		
		Query searchUserQuery = new Query(Criteria.where("username").is(user_id));
		Customer user = mongoOperation.findOne(searchUserQuery, Customer.class);
		Query searchHistory = new Query(Criteria.where("_id").is(Integer.parseInt(user.getCust_id())));		
		History userHistory = mongoOperation.findOne(searchHistory, History.class);
		
		List<AssociationRule> rules = mongoOperation.findAll(AssociationRule.class);
		Set<String> historyProducts=new HashSet<String>(Arrays.asList(userHistory.getValue()));
		Set<String> historyProductsNew=new HashSet<String>();
		for(String s:historyProducts)
		{
			historyProductsNew.add(clean(s));
		}
		List<AssociationRule> recommend=new ArrayList<AssociationRule>();
		for (AssociationRule a : rules) {
			System.out.println("--------------------");
			Set<String> ruleproducts = new HashSet<String>(Arrays.asList(a
					.getLhs().split(",")));
			Set<String> ruleProductsNew = new HashSet<String>();
			for (String s : ruleproducts) {
				ruleProductsNew.add(clean(s));
			}
			if (historyProductsNew.containsAll(ruleProductsNew)) {
				System.out.println("contains : " + ruleProductsNew);
				Set<String> ruleproduct = new HashSet<String>(Arrays.asList(a
						.getRhs().split(",")));
				Set<String> ruleProductNew = new HashSet<String>();
				for (String s : ruleproduct) {
					ruleProductNew.add(clean(s));
				}				
				if(beaconProductsNew.containsAll(ruleProductNew)){
					recommend.add(a);
				}
			}

		}
		return recommend;	
	}
	
	public String clean(String s){
		String temp;
		temp=s.replaceAll("[^a-zA-Z]+", "");
		return temp;
	}
	
	@RequestMapping(value = "/beacons", method = RequestMethod.GET)
	public List<Beacon> getBeacons() {
		List<Beacon> beaconList = mongoOperation.findAll(Beacon.class);
		if(beaconList != null)
		return beaconList ;
		else
		return null;		
	}
	
	@RequestMapping(value = "/TrendingProducts/{userid}/{password}/{majorid}/{minorid}", method = RequestMethod.GET)
	public MapReduce getTrendingProducts(@PathVariable("userid") String user_id, @PathVariable("password") String password,@PathVariable("majorid") String major_id,@PathVariable("minorid") String minor_id) {
		Query searchProducts = new Query(Criteria.where("major_id").is(major_id));
		Beacon beacon = mongoOperation.findOne(searchProducts, Beacon.class);
		Set<String> beaconProducts=new HashSet<String>(Arrays.asList(beacon.getProducts()));
		System.out.println(beaconProducts);
		Query getCount= new Query(Criteria.where("_id").in(beaconProducts));
		List<MapReduce> bProducts = mongoOperation.find(getCount, MapReduce.class);
		int max=0;
		MapReduce ret=null;
		Iterator<MapReduce> pIterator = bProducts.iterator();
		while (pIterator.hasNext()) {
			MapReduce m=pIterator.next();
			if(m.getValue()>max)
			{
				max=m.getValue();
				ret=m;			
			}
		}
		return ret;		
	}
	
	@RequestMapping(value = "/discount/{userid}/{password}/{majorid}/{minorid}", method = RequestMethod.GET)
	public Discount getDiscount(@PathVariable("userid") String user_id, @PathVariable("password") String password,@PathVariable("majorid") String major_id,@PathVariable("minorid") String minor_id) {
		Query searchProducts = new Query(Criteria.where("major_id").is(major_id));
		Beacon beacon = mongoOperation.findOne(searchProducts, Beacon.class);
		Set<String> beaconProducts=new HashSet<String>(Arrays.asList(beacon.getProducts()));
		System.out.println(beaconProducts);
		
		Query getCount= new Query(Criteria.where("_id").in(beaconProducts));
		List<MapReduce> bProducts = mongoOperation.find(getCount, MapReduce.class);
		int min=10000;
		MapReduce ret=null;
		Iterator<MapReduce> pIterator = bProducts.iterator();
		while (pIterator.hasNext()) {
			MapReduce m=pIterator.next();
			if(m.getValue()<min)
			{
				min=m.getValue();
				ret=m;			
			}
		}
		System.out.println("minimum : " + ret);
		Query getDiscount=new Query(Criteria.where("product").is(ret.get_id()));
		Discount discount=mongoOperation.findOne(getDiscount, Discount.class);
		return discount;		
	}
}
