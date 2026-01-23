// java
package com.example.provider.pact;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.TestTemplate;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;

import au.com.dius.pact.provider.junit5.HttpTestTarget;
import au.com.dius.pact.provider.junit5.PactVerificationContext;
import au.com.dius.pact.provider.junit5.PactVerificationInvocationContextProvider;
import au.com.dius.pact.provider.junitsupport.Provider;
import au.com.dius.pact.provider.junitsupport.State;
import au.com.dius.pact.provider.junitsupport.loader.PactFolder;

//@ExtendWith(SpringExtension.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Provider("ProductGraphQLProvider")
@PactFolder("src/test/resources/pacts")
public class ProductGraphQLProviderPactTest {

	@LocalServerPort
	private int port;

	@BeforeEach
	void before(PactVerificationContext context) {
		// Use the dynamically assigned port for the test
		context.setTarget(new HttpTestTarget("localhost", 8080, "/"));
	}

	@TestTemplate
	@ExtendWith(PactVerificationInvocationContextProvider.class)
	void pactVerificationTestTemplate(PactVerificationContext context) {
		context.verifyInteraction();
	}

	// Provider state handlers - implement these to configure the provider for each
	// state.

	@State("GraphQL Query - product found")
	public void productFound() {
		// Configure the provider to return a successful product for the interaction.
	}

	@State("GraphQL Query - product not found")
	public void productNotFound() {
		// e.g. ensure product id=999 is not present
	}

	@State("GraphQL Query - invalid argument")
	public void invalidArgument() {
		// e.g. no special setup; ensure provider returns GraphQL error for invalid id
		// format
	}

	@State("GraphQL Query - provider internal error")
	public void providerInternalError() {
		// e.g. configure provider to throw an internal error for id=2
	}
}
