package edu.sjsu.cmpe239;
import edu.sjsu.cpme239.model.AssociationRule;
import edu.sjsu.cmpe239.config.MongoConfig;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
public class MongoUtility {
/*	ApplicationContext ctx =  new AnnotationConfigApplicationContext(MongoConfig.class);
	MongoOperations mongoOperation = (MongoOperations) ctx.getBean("mongoTemplate");
	Query searchUserQuery = new Query(Criteria.where("_id").is("enter value here"));
    AssociationRule savedUser = mongoOperation.findOne(searchUserQuery, AssociationRule.class);
*/
}
